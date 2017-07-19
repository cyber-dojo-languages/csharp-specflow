
lambda { |stdout,stderr,status|
  output = stdout + stderr
  return :red   if /^\s*Test Count: \d+, Passed: \d+, Failed: [^0]\d*, Warnings: \d+, Inconclusive: \d+, Skipped: \d+/.match(output)
  return :green if /^\s*Overall result: Passed/.match(output)
  return :amber
}
