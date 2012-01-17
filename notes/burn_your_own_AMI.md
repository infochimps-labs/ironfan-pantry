
http://docs.amazonwebservices.com/AWSEC2/latest/UserGuide/AESDG-chapter-sharingamis.html

Remove SSH Host Key Pairs

If you plan to share an AMI derived from a public AMI, remove the existing SSH host key pairs located in /etc/ssh. This forces SSH to generate new unique SSH key pairs when someone launches an instance using your AMI, improving security and reducing the likelihood of "man-in-the-middle" attacks.
The SSH files to remove:

        ssh_host_dsa_key
        ssh_host_dsa_key.pub
        ssh_host_key
        ssh_host_key.pub
        ssh_host_rsa_key
        ssh_host_rsa_key.pub

Always delete the shell history before bundling. If you attempt more than one bundle upload in the same image, the shell history contains your secret access key.
Bundling a running instance requires your private key and X.509 certificate. Put these and other credentials in a location that is not bundled (such as the instance store).
Exclude the ssh authorized keys when bundling the image. The Amazon public images store the public key used to launch an instance with its ssh authorized keys file.

        if [ ! -d /root/.ssh ] ; then
                mkdir -p /root/.ssh
                chmod 700 /root/.ssh
        fi
        # Fetch public key using HTTP
        curl http://169.254.169.254/latest//meta-data/public-keys/0/openssh-key > /tmp/my-key
        if [ $? -eq 0 ] ; then
                cat /tmp/my-key >> /root/.ssh/authorized_keys
                chmod 700 /root/.ssh/authorized_keys
                rm /tmp/my-key
        fi

### Burning an Instance-backed (s3) AMIs

From your local machine, bring over your credentials

<pre><code>
  cluster=hoolock
  scp -i ~/.hadoop-ec2/keypairs/hoolock.pem ~/.hadoop-ec2/{certs/cert.pem,certs/pk.pem,keypairs/hoolock.pem} ubuntu@50.16.13.146:/tmp
</code></pre>

On the target machine:

<pre><code>
cd /mnt
eval $(sudo blkid /dev/sda1 | awk -F: '{ print $2 }') 
# credentials
AWS_ACCOUNT_ID=123456781234 AWS_ACCESS_KEY_ID=2341245 AWS_SECRET_ACCESS_KEY=125324635473465743674637
# ... move the keys to /mnt (so that they are ignored in the bundling)
sudo mv /tmp/*.pem /mnt
</code></pre>
  
Modify the following to suit. (A note about AMI_EXCLUDES: the ec2-bundle-vol
will complain about excluded dirs that don't exist -- remove those. Be careful
though, because it is a VERY BAD THING if directories that do exist (say, a
500GB attached drive) aren't excluded!)

<pre><code>

# edit these:
# i386 or x86_64
BITS=x86_64
# might need to add: /ebs1,/ebs2,/data,/var/lib/cassandra,/srv/chef/cache
AMI_EXCLUDES=/mnt,/mnt2,/root/.ssh/authorized_keys,/home/ubuntu/.ssh/authorized_keys

export EC2_CERT=/mnt/cert.pem
export EC2_PRIVATE_KEY=/mnt/pk.pem
kern=$(wget -q http://169.254.169.254/latest/meta-data/kernel-id -O -) ; echo $kern
eval `cat /etc/lsb-release `
AMI_BUCKET=s3amis.infinitemonkeys.info
ami_name=infochimps.chef-client.${DISTRIB_CODENAME}.east.ami-${BITS}-`date "+%Y%m%d"`
ami_bucket=${AMI_BUCKET}/$ami_name
sudo mkdir -p /mnt/$ami_bucket

# This will take a long fucking time (15 minutes on a small instance) so treat yourself to a large CPU-heavy machine when you're burninating
time sudo ec2-bundle-vol --kernel $kern --exclude=$AMI_EXCLUDES -r $BITS -d /mnt/$ami_bucket -u $AWS_ACCOUNT_ID --cert cert.pem --privatekey pk.pem --ec2cert /etc/ec2/amitools/cert-ec2.pem

( cd /mnt/$ami_bucket ; ec2-unbundle --manifest image.manifest.xml --destination /mnt --privatekey $EC2_PRIVATE_KEY  )

time ec2-bundle-image --image /mnt/image --kernel $kern -u $AWS_ACCOUNT_ID --cert cert.pem --privatekey pk.pem --ec2cert /etc/ec2/amitools/cert-ec2.pem

time ec2-upload-bundle    -b $ami_bucket -m /mnt/$ami_bucket/image.manifest.xml -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY
time ec2-register -n $ami_name -d $ami_name $ami_bucket/image.manifest.xml
</code></pre>

h4. If you are in a region other than us-east-1

# export AWS_REGION=us-west-1 
# export EC2_URL=https://${AWS_REGION}.ec2.amazonaws.com
# sudo mkdir -p /mnt/$ami_bucket
# time sudo ec2-bundle-vol --exclude=$AMI_EXCLUDES -d /mnt/$ami_bucket -u $AWS_ACCOUNT_ID --cert cert.pem --privatekey pk.pem --ec2cert /etc/ec2/amitools/cert-ec2.pem
# time ec2-migrate-manifest      --manifest /mnt/$ami_bucket/image.manifest.xml   --region   $AWS_REGION -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY 
# time ec2-upload-bundle    -b $ami_bucket -m /mnt/$ami_bucket/image.manifest.xml --location $AWS_REGION -a $AWS_ACCESS_KEY_ID -s $AWS_SECRET_ACCESS_KEY
# time ec2-register -n $ami_name -d $ami_name $ami_bucket/image.manifest.xml      --region $AWS_REGION

