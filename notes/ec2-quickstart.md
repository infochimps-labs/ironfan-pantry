
Before you can use these tools to launch Amazon AWS machines you must export
some variables to your $SHELL, and download your certificate and private key from
Amazon Web Services.

Your certificate and private key are available at:
http://aws-portal.amazon.com/gp/aws/developer/account/index.html?action=access-key

Download two ".pem" files, one starting with `pk-`, and one starting with
`cert-`.  You need to put both into a subfolder of your credentials directory, namely
`~/.chef/{organization}-credentials/ec2_certs`.

You may wish to use this as the directory for your ec2-api-tools; if so, set the
needed variables, and add them to your dotfiles.

 * On Bash, add them to `~/.bash_profile`.
 * On Zsh, add them to `~/.zprofile` instead.

        ec2_key_dir="$HOME/.chef/${CHEF_ORGANIZATION}-credentials/ec2_certs"
        export EC2_PRIVATE_KEY="$(/bin/ls $ec2_key_dir/pk-*.pem)"
        export EC2_CERT="$(/bin/ls $ec2_key_dir/cert-*.pem)"
