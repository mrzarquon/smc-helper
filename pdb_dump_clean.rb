require 'json'
require 'securerandom'

pfile = File.read('processors.json')
mfile = File.read('memory.json')
kfile = File.read('kernel.json')

processors = JSON.parse(pfile)
memory = JSON.parse(mfile)
kernel = JSON.parse(kfile)

cleanoutput = Array.new


processors.each do |pcert|
  id = SecureRandom.uuid
  cores = pcert['value']
  memory_rec = memory.select{ |hash| hash["certname"] == pcert['certname'] }
  mem = memory_rec[0]['value']
  kernel_rec = kernel.select{ |hash| hash["certname"] == pcert['certname'] }
  kern = kernel_rec[0]['value']
  machine = {'record' => id, 'memory' => mem, 'processors' => cores, 'kernel' => kern}
  cleanoutput << machine
end


instances = {
  'c4.large.linux' => 0,
  'c5.xlarge.linux' => 0,
  'm5.xlarge.linux' => 0,
  'm5.2xlarge.linux' => 0,
  'c5.2xlarge.linux' => 0,
  'm5.4xlarge.linux' => 0,
  'm5.12xlarge.linux' => 0,
  'c4.large.windows' => 0,
  'c5.xlarge.windows' => 0,
  'm5.xlarge.windows' => 0,
  'm5.2xlarge.windows' => 0,
  'c5.2xlarge.windows' => 0,
  'm5.4xlarge.windows' => 0,
  'm5.12xlarge.windows' => 0
}

def set_os(instancesize,oskernel,instances)
  case oskernel
  when 'windows'
    instances["#{instancesize}.windows"] += 1
  else
    instances["#{instancesize}.linux"] += 1
  end
  return instances
end


cleanoutput.each do |instance|
  case instance['memory'].to_int
  when 0..8200
    case instance['processors'].to_int
    when 0..2
      instances = set_os('c4.large',instance['kernel'].to_s, instances)
    else
      instances = set_os('c5.xlarge', instance['kernel'].to_s, instances)
    end
  when 8201..16200
    case instance['processors'].to_int
    when 0..4
      instances = set_os('m5.xlarge',instance['kernel'].to_s, instances)
    else
      instances = set_os('c5.2xlarge',instance['kernel'].to_s, instances)
    end
    # either m5.xlarge or c5.2xlarge
  when 16201..34000
    # m5.2xlarge
    instances = set_os('m5.2xlarge',instance['kernel'].to_s, instances)
  when 34001..66000
    # m5.4xlarge
    instances = set_os('m5.4xlarge',instance['kernel'].to_s, instances)
  else
    # this is giant machine
    # m5.12xlarge
    instances = set_os('m5.12xlarge',instance['kernel'].to_s, instances)
  end
end


File.open('puppetdb.json','w'){ |f| f << JSON.pretty_generate(cleanoutput) }
File.open('instances.json','w'){ |f| f << JSON.pretty_generate(instances) }
