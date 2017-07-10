
lambda { |stdout,stderr,status|
  output = stdout + stderr
  return :red   if /^Errors and Failures:/.match(output)
  return :green if /^Tests run: (\d+), Errors: 0, Failures: 0/.match(output)
  return :amber
}
