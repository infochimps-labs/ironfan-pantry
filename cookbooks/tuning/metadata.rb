maintainer       "Philip (flip) Kromer - Infochimps, Inc"
maintainer_email "coders@infochimps.com"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

description      "Apply OS-specific tuning using parameters set by recipes and roles"


recipe           "tuning::default",                    "calls out to the right tuning recipe based on platform"
recipe           "tuning::ubuntu",                     "Applies tuning for Ubuntu systems"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "tuning/overcommit_memory",
  :display_name          => "",
  :description           => "If virtual memory requests exceed available physical memory,\n* 0 = heuristic\n* 1 = allow until actually OOM.\n* 2 = Don't overcommit. The total address space commit for the system is not\npermitted to exceed swap + a percentage (the `overcommit_ratio`) of\nphysical RAM. Depending on the percentage you use, in most situations\nthis means a process will not be killed while accessing pages but will\nreceive errors on memory allocation as appropriate.\n(http://linux-mm.org/OverCommitAccounting)\nDedicated-purpose servers -- especially one that launch multiple unreflective\nJVMs (hello, Hadoop) or fork other processes (top of the morning, jenkins) --\nshould set this to 1",
  :default               => "1"

attribute "tuning/overcommit_ratio",
  :display_name          => "",
  :description           => "When overcommit_memory is set to 2, the committed address space is not\npermitted to exceed swap plus this percentage of physical RAM.",
  :default               => "100"

attribute "tuning/swappiness",
  :display_name          => "",
  :description           => "How aggressive the kernel will swap memory pages.  Higher values will increase\nagressiveness, lower values decrease the amount of swap.\nSince dedicated servers prefer the process death of OOM to the machine-wide\ndeath of swap churn, make the machine be as agressive as possible.",
  :default               => "5"
