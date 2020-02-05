require './lib/report_generator'

class Report
  attr_reader :file

  def initialize
    @file = File.readlines(ARGV[0])
  end

  def generate_report!
    report = report_generator.generate_report!
    File.write('output.txt', report.join)
    puts '----------------------------------------'
    puts "Generated file output.txt with contents: \n\n"
    puts report
    puts '----------------------------------------'
  end
  
  def report_generator
    ReportGenerator.new(file)
  end

end

report = Report.new
report.generate_report!