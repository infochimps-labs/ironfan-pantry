

chef server:

    /etc/chef/
      validator.pem        = credentials/cocina-validator.pem

      dna.json
      client.pem           = credentials/client_keys/client-cocina-chef_server-0.pem (don't really need to keep this tho)
      cocina-validator.pem = credentials/cocina-validator.pem

chef client:

    /etc/chef/
      client.rb            = ?? /client.rb
      dna.json             = credentials/dna/cocina-chef_server-0.json
      client.pem           = credentials/client_keys/client-cocina-chef_server-0.pem (don't really need to keep this tho)
      cocina-validator.pem = credentials/cocina-validator.pem
