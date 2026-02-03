model MyMod

  extends ThermoFluidStreamTutorial.Utilities.BaseModel(ambientTemperature=308.15);

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                      prescribedHeatFlow1(Q_flow(displayUnit="W"))   annotation (Placement(transformation(extent={{-150,0},{-130,20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor thermalMassBattery(C=4e5, T(fixed=true, start=ambientTemperature)) annotation (Placement(transformation(extent={{-130,20},{-110,40}})));
  ThermofluidStream.Processes.ConductionElement coldPlate(
    redeclare package Medium = Coolant,
    initM_flow=ThermofluidStream.Utilities.Types.InitializationMethods.state,
    m_flow_0=0,
    V=0.0005,
    init=ThermofluidStream.Processes.Internal.InitializationMethodsCondElement.T,
    T_0=ambientTemperature,
    enforce_global_energy_conservation=false,
    resistanceFromAU=false,
    k_par=1800) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-90,10})));
  inner ThermofluidStream.DropOfCommons dropOfCommons(displayInstanceNames=true, displayParameters=true) annotation (Placement(transformation(extent={{-240,92},{-220,112}})));
  ThermofluidStream.Processes.FlowResistance flowResistanceLiquid(
    redeclare package Medium = Coolant,
    redeclare function pLoss = ThermofluidStream.Processes.Internal.FlowResistance.referencePressureLoss (
        dp_ref(displayUnit="kPa") = 250000,
        m_flow_ref=1.2,
        rho_ref(displayUnit="kg/m3") = 1000,
        dp_function=ThermofluidStream.Processes.Internal.ReferencePressureDropFunction.quadratic),
    l=8,
    r(displayUnit="mm") = 0.001*(13/2)) annotation (Placement(transformation(extent={{-78,50},{-58,70}})));
  ThermofluidStream.Processes.CentrifugalPump centrifugalPump(
    redeclare package Medium = Coolant,
    dataFromMeasurements=false,
    redeclare ThermofluidStream.Processes.Internal.CentrifugalPump.Coefficients.GenericPump coefficients(
      rho_ref(displayUnit="kg/m3"),
      w_ref=628.31853071796,
      V_flow_peak=0.0012027777777778,
      setHead=false,
      dp_peak(displayUnit="kPa") = 250000,
      eta_peak=0.6),
    pumpMode=ThermofluidStream.Processes.Internal.Types.PumpMode.flange) annotation (Placement(transformation(extent={{-20,-90},{-40,-70}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J=2e-3, phi(fixed=true, start=0),
    w(fixed=true, start=0))                                                                  annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-110})));
  ThermofluidStream.Boundaries.Sink sink(redeclare package Medium = Air, p0_par(displayUnit="bar") = 100000) annotation (Placement(transformation(extent={{140,20},{160,40}})));
  ThermofluidStream.Boundaries.VolumeFlex volumeFlex(
    redeclare package Medium = Coolant,
    p_start=200000,
    T_start=ambientTemperature,
    usePreferredMediumStates=false,
    p_ref=200000,
    V_ref=0.005,
    K(displayUnit="MPa") = 1500000) annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  ThermofluidStream.HeatExchangers.CounterFlowNTU counterFlowNTU(
    redeclare package MediumA = Air,
    redeclare package MediumB = Coolant,
    A=50,
    k_NTU=100,
    TC=3.5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,0})));
  ThermofluidStream.Boundaries.Source source(
    redeclare package Medium = Air,
    p0_par=100000,
    T0_par=ambientTemperature) annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  ThermofluidStream.Processes.FlowResistance flowResistanceAir(
    redeclare package Medium = Air,
    initM_flow=ThermofluidStream.Utilities.Types.InitializationMethods.state,
    redeclare function pLoss = ThermofluidStream.Processes.Internal.FlowResistance.referencePressureLoss (
        dp_ref(displayUnit="Pa") = 20,
        m_flow_ref=0.8,
        rho_ref(displayUnit="kg/m3") = 1.2,
        dp_function=ThermofluidStream.Processes.Internal.ReferencePressureDropFunction.quadratic),
    l=0.1,
    shape=ThermofluidStream.Processes.Internal.ShapeOfResistance.rectangle,
    r(displayUnit="mm"),
    a=0.6,
    b=0.2) annotation (Placement(transformation(extent={{50,20},{70,40}})));
  ThermofluidStream.Processes.FlowResistance exitLoss(
    redeclare package Medium = Air,
    redeclare function pLoss = ThermofluidStream.Processes.Internal.FlowResistance.zetaPressureLoss (zeta=1),
    l=0.2,
    shape=ThermofluidStream.Processes.Internal.ShapeOfResistance.rectangle,
    r(displayUnit="m"),
    a=0.6,
    b=0.2,
    computeL=true) annotation (Placement(transformation(extent={{110,20},{130,40}})));
  ThermofluidStream.Processes.Fan fan(redeclare package Medium = Air, redeclare function dp_tau_fan = ThermoFluidStreamTutorial.Utilities.characteristicsTutorial (
        omega_ref=314.15926535898,
        m_flow_ref=0.8*1.5,
        dp_ref(displayUnit="Pa") = 70*1.5,
        skew=0.1,
        eta=0.5)) annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia1(J=5e-3, phi(fixed=true, start=0)) annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed1 annotation (Placement(transformation(extent={{150,-10},{130,10}})));
  Modelica.Blocks.Sources.RealExpression fanSpeed(y=3000) annotation (Placement(transformation(extent={{210,-10},{190,10}})));
  Modelica.Blocks.Math.UnitConversions.From_rpm from_rpm1 annotation (Placement(transformation(extent={{180,-10},{160,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-170,-20})));
  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=batteryTargetTemperature) annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));
  ThermofluidStream.FlowControl.Switch bypass(redeclare package Medium = Coolant, invertInput=false)
                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-8,60})));
  ThermofluidStream.Topology.JunctionT2 junction(redeclare package Medium = Coolant, inletA(m_flow(start=0, fixed=true)))
                                                                                     annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={24,-40})));
  ThermoFluidStreamTutorial.Utilities.PTCLogic ptcLogic(
    power(displayUnit="kW") = 7000,
    startHeating=startHeating,
    stopHeating=stopHeating) annotation (Placement(transformation(extent={{-180,-56},{-160,-36}})));
  ThermofluidStream.Processes.ConductionElement ptcHeater(
    redeclare package Medium = Coolant,
    initM_flow=ThermofluidStream.Utilities.Types.InitializationMethods.state,
    m_flow_0=0,
    V=0.0001,
    init=ThermofluidStream.Processes.Internal.InitializationMethodsCondElement.T,
    T_0=ambientTemperature,
    enforce_global_energy_conservation=false,
    resistanceFromAU=false,
    k_par=80) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-90,-40})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor thermalMassPTC(C=2100, T(fixed=true, start=ambientTemperature)) annotation (Placement(transformation(extent={{-130,-52},{-110,-72}})));
  ThermoFluidStreamTutorial.Utilities.BypassLogic bypassLogic(openBypass=stopCooling, closeBypass=startCooling) annotation (Placement(transformation(extent={{-68,80},{-48,100}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                      prescribedHeatFlow(Q_flow(displayUnit="W"))    annotation (Placement(transformation(extent={{-148,-50},{-128,-30}})));
  ThermoFluidStreamTutorial.Utilities.PumpControl pumpControl(isHeaterOn=ptcLogic.isPTCOn, isBypassClosed=not bypassLogic.isBypassOpen) annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Modelica.Blocks.Sources.Step step(height=5000, startTime=2500) annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  ThermofluidStream.FlowControl.Switch bypass1(redeclare package Medium = Coolant, invertInput=false)
                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={24,60})));
  ThermofluidStream.Topology.JunctionT2 junction1(redeclare package Medium = Coolant, inletA(m_flow(start=0, fixed=true)))
                                                                                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={24,-80})));
  ThermofluidStream.Boundaries.Sink sink1(redeclare package Medium = Air, p0_par(displayUnit="bar") = 100000)
                                                                                                             annotation (Placement(transformation(extent={{390,40},{410,60}})));
  ThermofluidStream.Boundaries.Source source1(
    redeclare package Medium = Air,
    p0_par=100000,
    T0_par=ambientTemperature) annotation (Placement(transformation(extent={{320,-60},{300,-40}})));
  ThermofluidStream.Processes.FlowResistance flowResistanceAir1(
    redeclare package Medium = Air,
    initM_flow=ThermofluidStream.Utilities.Types.InitializationMethods.state,
    redeclare function pLoss = ThermofluidStream.Processes.Internal.FlowResistance.referencePressureLoss (
        dp_ref(displayUnit="Pa") = 20,
        m_flow_ref=0.8,
        rho_ref(displayUnit="kg/m3") = 1.2,
        dp_function=ThermofluidStream.Processes.Internal.ReferencePressureDropFunction.quadratic),
    l=0.1,
    shape=ThermofluidStream.Processes.Internal.ShapeOfResistance.rectangle,
    r(displayUnit="mm"),
    a=0.6,
    b=0.2) annotation (Placement(transformation(extent={{300,40},{320,60}})));
  ThermofluidStream.Processes.FlowResistance exitLoss1(
    redeclare package Medium = Air,
    redeclare function pLoss = ThermofluidStream.Processes.Internal.FlowResistance.zetaPressureLoss (zeta=1),
    l=0.2,
    shape=ThermofluidStream.Processes.Internal.ShapeOfResistance.rectangle,
    r(displayUnit="m"),
    a=0.6,
    b=0.2,
    computeL=true) annotation (Placement(transformation(extent={{360,40},{380,60}})));
  ThermofluidStream.Processes.Fan fan1(redeclare package Medium = Air, redeclare function dp_tau_fan = ThermoFluidStreamTutorial.Utilities.characteristicsTutorial (
        omega_ref=314.15926535898,
        m_flow_ref=0.8*1.5,
        dp_ref(displayUnit="Pa") = 70*1.5,
        skew=0.1,
        eta=0.5)) annotation (Placement(transformation(extent={{330,40},{350,60}})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia2(J=5e-3, phi(fixed=true, start=0)) annotation (Placement(transformation(extent={{370,10},{350,30}})));
  Modelica.Mechanics.Rotational.Sources.Speed speed2 annotation (Placement(transformation(extent={{400,10},{380,30}})));
  Modelica.Blocks.Sources.RealExpression fanSpeed1(y=3000)
                                                          annotation (Placement(transformation(extent={{460,10},{440,30}})));
  Modelica.Blocks.Math.UnitConversions.From_rpm from_rpm2 annotation (Placement(transformation(extent={{430,10},{410,30}})));
  ThermoFluidStreamTutorial.Internal.WorkingOn.VapourCycleSystem vcs annotation (Placement(transformation(
        extent={{30,-30},{-30,30}},
        rotation=270,
        origin={250,10})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0)                       annotation (Placement(transformation(extent={{60,80},{40,100}})));
equation
  connect(prescribedHeatFlow1.port, thermalMassBattery.port) annotation (Line(points={{-130,10},{-120,10},{-120,20}}, color={191,0,0}));
  connect(coldPlate.outlet, flowResistanceLiquid.inlet) annotation (Line(
      points={{-90,20},{-90,60},{-78,60}},
      color={28,108,200},
      thickness=0.5));
  connect(inertia.flange_b, centrifugalPump.flange) annotation (Line(points={{-30,-100},{-30,-90}},          color={0,0,0}));
  connect(flowResistanceLiquid.outlet, volumeFlex.inlet) annotation (Line(
      points={{-58,60},{-48,60}},
      color={28,108,200},
      thickness=0.5));
  connect(source.outlet, counterFlowNTU.inletA) annotation (Line(
      points={{60,-30},{36,-30},{36,-10}},
      color={28,108,200},
      thickness=0.5));
  connect(counterFlowNTU.outletA, flowResistanceAir.inlet) annotation (Line(
      points={{36,10},{36,30},{50,30}},
      color={28,108,200},
      thickness=0.5));
  connect(exitLoss.outlet, sink.inlet) annotation (Line(
      points={{130,30},{140,30}},
      color={28,108,200},
      thickness=0.5));
  connect(flowResistanceAir.outlet, fan.inlet) annotation (Line(
      points={{70,30},{80,30}},
      color={28,108,200},
      thickness=0.5));
  connect(fan.outlet, exitLoss.inlet) annotation (Line(
      points={{100,30},{110,30}},
      color={28,108,200},
      thickness=0.5));
  connect(speed1.flange, inertia1.flange_a) annotation (Line(points={{130,0},{120,0}}, color={0,0,0}));
  connect(from_rpm1.y, speed1.w_ref) annotation (Line(points={{159,0},{152,0}}, color={0,0,127}));
  connect(fanSpeed.y, from_rpm1.u) annotation (Line(points={{189,0},{182,0}}, color={0,0,127}));
  connect(inertia1.flange_b, fan.flange) annotation (Line(points={{100,0},{90,0},{90,20}},   color={0,0,0}));
  connect(thermalMassBattery.port, temperatureSensor.port) annotation (Line(points={{-120,20},{-120,-20},{-160,-20}},
                                                                                                          color={191,0,0}));
  connect(torque.flange, inertia.flange_a) annotation (Line(points={{-60,-130},{-30,-130},{-30,-120}},
                                                                                                    color={0,0,0}));
  connect(counterFlowNTU.outletB, junction.inletB) annotation (Line(
      points={{24,-10},{24,-30}},
      color={28,108,200},
      thickness=0.5));
  connect(volumeFlex.outlet,bypass. inlet) annotation (Line(
      points={{-28,60},{-18,60}},
      color={28,108,200},
      thickness=0.5));
  connect(bypass.outletB, junction.inletA) annotation (Line(
      points={{-8,50},{-8,-40},{14,-40}},
      color={28,108,200},
      thickness=0.5));
  connect(ptcLogic.batteryTemperature, temperatureSensor.T) annotation (Line(points={{-182,-46},{-190,-46},{-190,-20},{-181,-20}},
                                                                                                                        color={0,0,127}));
  connect(ptcHeater.outlet, coldPlate.inlet) annotation (Line(
      points={{-90,-30},{-90,0}},
      color={28,108,200},
      thickness=0.5));
  connect(centrifugalPump.outlet, ptcHeater.inlet) annotation (Line(
      points={{-40,-80},{-90,-80},{-90,-50}},
      color={28,108,200},
      thickness=0.5));
  connect(bypassLogic.bypassSignal, bypass.u) annotation (Line(points={{-47,96},{-8,96},{-8,72}},
                                                                                                color={0,0,127}));
  connect(bypassLogic.batteryTemperature, temperatureSensor.T) annotation (Line(points={{-68,90},{-190,90},{-190,-20},{-181,-20}},            color={0,0,127}));
  connect(thermalMassPTC.port, ptcHeater.heatPort) annotation (Line(points={{-120,-52},{-120,-40},{-100,-40}}, color={191,0,0}));
  connect(prescribedHeatFlow.port, ptcHeater.heatPort) annotation (Line(points={{-128,-40},{-100,-40}}, color={191,0,0}));
  connect(ptcLogic.Q_flow, prescribedHeatFlow.Q_flow) annotation (Line(points={{-159,-40},{-148,-40}}, color={0,0,127}));
  connect(coldPlate.heatPort, thermalMassBattery.port) annotation (Line(points={{-100,10},{-120,10},{-120,20}},
                                                                                                    color={191,0,0}));
  connect(realExpression.y, pumpControl.u_s) annotation (Line(points={{-139,-130},{-122,-130}}, color={0,0,127}));
  connect(temperatureSensor.T, pumpControl.u_m) annotation (Line(points={{-181,-20},{-190,-20},{-190,-150},{-110,-150},{-110,-142}},
                                                                                                                          color={0,0,127}));
  connect(pumpControl.y, torque.tau) annotation (Line(points={{-99,-130},{-82,-130}},  color={0,0,127}));
  connect(step.y, prescribedHeatFlow1.Q_flow) annotation (Line(points={{-159,10},{-150,10}}, color={0,0,127}));
  connect(bypass.outletA, bypass1.inlet) annotation (Line(
      points={{2,60},{14,60}},
      color={28,108,200},
      thickness=0.5));
  connect(bypass1.outletB, counterFlowNTU.inletB) annotation (Line(
      points={{24,50},{24,10}},
      color={28,108,200},
      thickness=0.5));
  connect(junction.outlet, junction1.inletA) annotation (Line(
      points={{24,-50},{24,-70}},
      color={28,108,200},
      thickness=0.5));
  connect(junction1.outlet, centrifugalPump.inlet) annotation (Line(
      points={{14,-80},{-20,-80}},
      color={28,108,200},
      thickness=0.5));
  connect(exitLoss1.outlet, sink1.inlet) annotation (Line(
      points={{380,50},{390,50}},
      color={28,108,200},
      thickness=0.5));
  connect(flowResistanceAir1.outlet, fan1.inlet) annotation (Line(
      points={{320,50},{330,50}},
      color={28,108,200},
      thickness=0.5));
  connect(fan1.outlet, exitLoss1.inlet) annotation (Line(
      points={{350,50},{360,50}},
      color={28,108,200},
      thickness=0.5));
  connect(speed2.flange,inertia2. flange_a) annotation (Line(points={{380,20},{370,20}},
                                                                                       color={0,0,0}));
  connect(from_rpm2.y,speed2. w_ref) annotation (Line(points={{409,20},{402,20}},
                                                                                color={0,0,127}));
  connect(fanSpeed1.y, from_rpm2.u) annotation (Line(points={{439,20},{432,20}}, color={0,0,127}));
  connect(inertia2.flange_b, fan1.flange) annotation (Line(points={{350,20},{340,20},{340,40}}, color={0,0,0}));
  connect(bypass1.outletA, vcs.inletEvaporatorSecondary) annotation (Line(
      points={{34,60},{232,60},{232,40}},
      color={28,108,200},
      thickness=0.5));
  connect(vcs.outletEvaporatorSecondary, junction1.inletB) annotation (Line(
      points={{232,-20},{232,-80},{34,-80}},
      color={28,108,200},
      thickness=0.5));
  connect(flowResistanceAir1.inlet, vcs.outletCondenserSecondary) annotation (Line(
      points={{300,50},{268,50},{268,40}},
      color={28,108,200},
      thickness=0.5));
  connect(source1.outlet, vcs.inletCondenserSecondary) annotation (Line(
      points={{300,-50},{268,-50},{268,-20}},
      color={28,108,200},
      thickness=0.5));
  connect(realExpression1.y, bypass1.u) annotation (Line(points={{39,90},{24,90},{24,72}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-160},{260,160}})),
    experiment(StopTime=3600));
end MyMod;
