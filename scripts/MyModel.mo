model Pendulum
  constant Real g = 9.81;
  parameter Real L = 1.0;
  Real theta(start = 0.5);
  Real omega(start = 0.0);
equation
  der(theta) = omega;
  der(omega) = -(g/L) * sin(theta);
end Pendulum;