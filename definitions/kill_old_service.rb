
define(:kill_old_service,
  :script       => nil,
  :hard         => false,
  ) do
  params[:script] ||= "/etc/init.d/#{params[:name]}"

  # cheating: don't bother if the script isn't there
  if (File.exists?(params[:script]))

    service params[:name] do
      action      [:stop, :disable]
      pattern     params[:pattern] if params[:pattern]
      only_if{ File.exists?(params[:script]) }
    end

    ruby_block("stop #{params[:name]}") do
      block{   }
      action      :create
      notifies    :stop, "service[#{params[:name]}]", :immediately
      only_if{ File.exists?(params[:script]) }
    end

    if params[:hard] # sometimes these shitty little things gotta be told thrice
      bash "stop again" do
        code "service #{params[:name]} stop ; sleep 1 ; service #{params[:name]} stop ; true"
        only_if{ File.exists?(params[:script]) }
      end
    end

    file(params[:script]) do
      action :delete
    end
  end
end
