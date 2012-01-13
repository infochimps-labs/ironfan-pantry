## Compute Costs

code    	$/mo	$/day	$/hr	CPU/$	Mem/$	 mem	cpu	cores	cpcore	storage	 bits	IO             	type      	name
t1.micro    	  14	 0.48	$0.02	10.00	33.50	 0.67	 0.2	1	 0.2  	   0	   64	Low      	Micro    	Micro
m1.small    	  61	 2.04	$0.085	11.76	20.00	 1.7	 1	1	 1	 160	   32	Moderate	Standard	Small
c1.medium   	 123	 4.08	$0.17	29.41	10.00	 1.7	 5	2	 2.5	 350	   32	Moderate	High-CPU	Medium
m1.large    	 246	 8.16	$0.34	11.76	22.06	 7.5	 4	2	 2	 850	   64	High    	Standard	Large
m2.xlarge   	 363	12.00	$0.50	13.00	35.40	17.7	 6.5	2	 3.25	 420	   64	Moderate	High-Memory	Extra Large
c1.xlarge   	 493	16.32	$0.68	29.41	10.29	 7	20	8	 2.5	1690	   64	High    	High-CPU	Extra Large
m1.xlarge   	 493	16.32	$0.68	11.76	22.06	15	 8	4	 2	1690	   64	High    	Standard	Extra Large
m2.2xlarge  	 726	24.00	$1.00	13.00	34.20	34.2	13	4	 3.25	 850	   64	High    	High-Memory	Double Extra Large
m2.4xlarge  	1452	48.00	$2.00	13.00	34.20	68.4	26	8	 3.25	1690	   64	High    	High-Memory	Quadruple Extra Large
cc1.4xlarge 	1161	38.40	$1.60	20.94	14.38	23	33.5	2	16.75	1690	   64	Very High 10GB	Compute  	Quadruple Extra Large
cg1.4xlarge 	1524	50.40	$2.10	15.95	10.48	22	33.5	2	16.75	1690	   64	Very High 10GB	Cluster GPU	Quadruple Extra Large


## Storage Costs

               	$/GB.hr	$/GB.mo		$/GB.mo	$/Mio	
EBS Volume     			$0.10				
EBS Snapshot S3			$0.14				
EBS I/O         			$0.10 			

S3 1st tb      	$0.14/gb/month
S3 next 49tb   	$0.125/gb/month
S3 next 450tb  	$0.110/gb/month

### Storing 1TB data

(Cost of storage, neglecting I/O costs, and assuming the ratio of EBS volume size to snapshot size is as given)






* http://aws.amazon.com/ec2/instance-types/
* http://aws.amazon.com/ec2/#pricing


### How much does EBS cost?

The costs of EBS will be similar to the pricing structure of data storage on S3.  There are three types of costs associated with EBS.

Storage Cost + Transaction Cost + S3 Snapshot Cost = Total Cost of EBS

NOTE: For current pricing information, be sure to check Amazon EC2 Pricing.

Storage Costs
The cost of an EBS Volume is $0.10/GB per month.  You are responsible for paying for the amount of disk space that you reserve, not for the amount of the disk space that you actually use.  If you reserve a 1TB volume, but only use 1GB, you will be paying for 1TB.
$0.10/GB per month of provisioned storage
$0.10/GB per 1 million I/O requests
 
Transaction Costs
In addition to the storage cost for EBS Volumes, you will also be charged for I/O transactions. The cost is $0.10 per million I/O transactions, where one transaction is equivalent to one read or write.  This number may be smaller than the actual number of transactions performed by your application because of the Linux cache for all file systems.
$0.10 per 1 million I/O requests
 
S3 Snapshot Costs
Snapshot costs are compressed and based on altered blocks from the previous snapshot backup.  Files that have altered blocks on the disk and then been deleted will add cost to the Snapshots for example.  Remember, snapshots are at the data block level.
$0.15 per GB-month of data stored
$0.01 per 1,000 PUT requests (when saving a snapshot)
$0.01 per 10,000 GET requests (when loading a snapshot)

NOTE:  Payment charges stop the moment you delete a volume.  If you delete a volume and the status appears as "deleting" for an extended period of time, you will not be charged for the time needed to complete the deletion.

 
