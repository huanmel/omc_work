from logging import root
from IPython.core.magic import register_line_magic, Magics, magics_class, cell_magic, register_cell_magic
from IPython import get_ipython
from OMPython import OMCSessionZMQ
import shlex
from pathlib import Path
import os

@register_line_magic
def my_magic(line):
    """
    My custom line magic.
    Usage: %my_magic <arguments>
    """
    print(f"You passed the following arguments: {line}")
    # Add your logic here

@magics_class
class ModelicaMagics(Magics):
    def __init__(self, shell):
        super().__init__(shell)
        self.omc = OMCSessionZMQ()
        # Optional: load standard libraries once at startup
        self.omc.sendExpression("loadModel(Modelica)")
        print("OMCSessionZMQ ready. Modelica standard library loaded.")
        print(f"OpenModelica version: {self.omc.sendExpression('getVersion()')}")
        model_path=self.omc.sendExpression("getInstallationDirectoryPath()")
        print(f"OpenModelica installation path: {model_path}")
        self.rootPath=Path.resolve(Path(Path.cwd()).parent).as_posix()+"/"
        self.currentDir=self.omc.sendExpression("cd();")
        self.workDir=None
        self.model_name='Model'
        print(f"Root path: {self.rootPath}")
        print(f"Current directory: {self.currentDir}")
    
    def change_work_dir(self, model_name=None):
        # model_name=self.model_name
        if model_name is None:
            model_name="Model"
            print(f"Model name not set.Would be used {model_name} folder as default.")
            
        workDir = self.rootPath + "work/"+model_name+"/"
        currentDir = self.omc.sendExpression("cd();")
        if self.omc.sendExpression(f'directoryExists("{workDir}")'):
            print(f"work dir is not empty and would be deleted\n: {workDir}")
            self.omc.sendExpression(f'remove("{workDir}");')
        self.omc.sendExpression(f'mkdir("{workDir}");')
        self.omc.sendExpression(f'cd("{workDir}");')
        print(f"Changed working directory to: {workDir}")
        self.currentDir=currentDir
        self.workDir=workDir
        
        return currentDir, workDir
    
    def change_dir_to_root(self):
        print(f'change ocm dir to root {self.rootPath}')
        self.omc.sendExpression(f'cd("{self.rootPath}");')
        self.omc.sendExpression(f'cd();')
        
        
   
    @cell_magic
    def modelica_script(self, line, cell):
        self.change_dir_to_root()
        line_args = shlex.split(line)  # better than .split() for quoted args
        cmds = cell.splitlines()
        for cmd in cmds:
            print(f"cmd: {cmd}")
            ans = self.omc.sendExpression(cmd)
            if ans:
                print(f"ans: {ans}")
            err = self.omc.sendExpression("getErrorString();")
            if err:
                print(err)
            
        
    
    @cell_magic
    def modelica(self, line, cell):
        """
        %%modelica [simulate] [ModelName] [--stopTime 5] [--vars theta,omega] [--format mat/csv]
        
        - Without arguments → just load & check model
        - With 'simulate' → load, simulate, read selected variables, return structured dict
        """
        line_args = shlex.split(line)  # better than .split() for quoted args
        model_path=self.omc.sendExpression("getInstallationDirectoryPath()")
        print(f"OpenModelica installation path: {model_path}")
        
        mode = "load"  # default: just load + check
        model_name = None
        stop_time = "1.0"
        variables = ["time"]           # always include time
        output_format = "mat"

        if line_args:
            if line_args[0].lower() == "simulate":
                mode = "simulate"
                line_args = line_args[1:]

            # Simple parsing of --key value
            i = 0
            while i < len(line_args):
                arg = line_args[i]
                if arg == "--stopTime" and i+1 < len(line_args):
                    stop_time = line_args[i+1]
                    i += 2
                elif arg == "--vars" and i+1 < len(line_args):
                    variables.extend(v.strip() for v in line_args[i+1].split(",") if v.strip())
                    i += 2
                elif arg == "--format" and i+1 < len(line_args):
                    output_format = line_args[i+1]
                    i += 2
                elif model_name is None and not arg.startswith("-"):
                    model_name = arg
                    i += 1
                else:
                    i += 1
                    
        # -------------------------------------------------------------------------
        # Try to find model name if not given explicitly
        # -------------------------------------------------------------------------
        if model_name is None and "model " in cell:
            # very naive extraction - improve if needed
            parts = cell.split("model ", 1)[1].split(None, 1)[0]
            model_name = parts.strip()

        if not model_name:
            print("Could not determine model name")
            return {"success": False, "errors": "No model name found or provided"}

        
        print(f"model_name: {model_name}, mode: {mode}, stop_time: {stop_time}, variables: {variables}, output_format: {output_format}")
        self.model_name=model_name
        self.change_work_dir(model_name=model_name)
        # -------------------------------------------------------------------------
        # 1. Load the model code from cell
        # -------------------------------------------------------------------------
        print("Loading Modelica code...")
        load_ok = self.omc.sendExpression(f'loadString("{cell}");')
        err = self.omc.sendExpression("getErrorString();")
        print(self.omc.sendExpression("getErrorString();"))



        # -------------------------------------------------------------------------
        # 2. Check model
        # -------------------------------------------------------------------------
        exists = self.omc.sendExpression(f"isModel({model_name})")
        print(f"isModel({model_name}) → {exists}")   # should be True
        
        if not exists:
            print("Load failed:")
            print(err or "Unknown load error")
            return {"success": False, "load_ok": load_ok, "errors": err}
        
        check = False
        check = self.omc.sendExpression(f"checkModel({model_name})")
        err = self.omc.sendExpression("getErrorString();")
        if "warning" in check.lower() or "error" in check.lower() or err:
            print(f"CheckModel issues for {model_name}:")
            print(check)
            if err: print(err)

        # -------------------------------------------------------------------------
        if mode != "simulate":
            return {"success": True, "model_name": model_name, "check": check, "errors": err}

        # -------------------------------------------------------------------------
        # 3. Simulate
        # -------------------------------------------------------------------------
        sim_cmd = (
            f'simulate({model_name}, '
            f'stopTime={stop_time}, '
            f'outputFormat="{output_format}");'
        )
        
        sim_result = self.omc.sendExpression(sim_cmd)
        err = self.omc.sendExpression("getErrorString();")
        if not isinstance(sim_result, dict) or "resultFile" not in sim_result:
            print("Simulation failed:")
            print(sim_result)
            if err: print(err)
            return {"success": False, "simulation": sim_result, "errors": err}

        # -------------------------------------------------------------------------
        # 4. Read interesting variables
        # -------------------------------------------------------------------------
        res_file = sim_result.get("resultFile", f"{model_name}_res.mat")
        
        # readSimulationResult( file, {time, theta, omega} ) → list of lists
        var_list_str = "{" + ", ".join(variables) + "}"
        data = self.omc.sendExpression(
            f'readSimulationResult("{res_file}", {var_list_str});'
        )

        # data = [ [time values], [var1 values], [var2 values], ... ]
        result_dict = {"time": data[0]}
        for i, var in enumerate(variables[1:], 1):  # skip time
            result_dict[var] = data[i]

        # -------------------------------------------------------------------------
        # Final return structure – user can assign: res = %%modelica simulate ...
        # -------------------------------------------------------------------------
        full_result = {
            "success": True,
            "model_name": model_name,
            "simulation_meta": sim_result,          # dict with times, resultFile, messages, ...
            "data": result_dict,                    # {"time": [...], "theta": [...], ...}
            "variables": variables,
            "errors": err if err else None,
            "check_model": check
        }

        # Optional: show short summary
        print(f"Simulation done. {len(result_dict.get('time', []))} points, variables: {variables}")
        if err:
            print("Warnings/errors:", err)

        return full_result   
    


# @cell_magic
    # def modelica(self, line, cell):
    #     """Execute Modelica code"""
    #     # Load the Modelica code
    #     print("Loading Modelica code...")
        
    #     result = self.omc.sendExpression(f'loadString("{cell}");')
    #     self.omc.sendExpression('print(getErrorString());')
    #     # If simulation, plot results
    #     if line.strip() == 'simulate':
    #         model_name = cell.split('model ')[1].split()[0]
    #         cmds = [
    #                 f'res=simulate({model_name}, stopTime=1);',
    #                 "plot(theta)"
    #                 ]
            
    #         for cmd in cmds:
    #             answer = self.omc.sendExpression(cmd)
    #             print("\n{}:\n{}".format(cmd, answer))
    #         # self.omc.sendExpression(f'res=simulate({model_name}, stopTime=1);')
            
    #         # Read and plot results
    #         # import matplotlib.pyplot as plt
    #         # import numpy as np
            
    #         # result = self.omc.sendExpression(f'readSimulationResult("{model_name}_res.mat");')
            
    #         result = self.omc.sendExpression(f'readSimulationResult("{model_name}_res.mat", {{time, theta}})')
    #         # time = [row[0] for row in result]
    #         # theta = [row[1] for row in result]
            
    #         # plt.figure()
    #         # plt.plot(time, theta)
    #         # plt.xlabel('Time')
    #         # plt.ylabel('Theta')
    #         # plt.title(f'{model_name} Results')
    #         # plt.show()
            
    #     return result