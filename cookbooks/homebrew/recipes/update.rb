ruby_block "trigger homebrew update" do
  notifies :run, "execute[update homebrew]", :immediately
  block{}
end
