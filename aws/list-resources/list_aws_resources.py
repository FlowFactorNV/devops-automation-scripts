import boto3
import argparse
from tabulate import tabulate

def list_ec2_instances(session):
    ec2 = session.client('ec2')
    response = ec2.describe_instances()
    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            launch_time = instance.get('LaunchTime', 'N/A')
            name = ""
            for tag in instance.get("Tags", []):
                if tag["Key"] == "Name":
                    name = tag["Value"]
            instances.append([
                instance['InstanceId'],
                name,
                instance['InstanceType'],
                instance['State']['Name'],
                instance.get('PublicIpAddress', 'N/A'),
                launch_time,
                ec2.meta.region_name
            ])
    return instances, ["Instance ID", "Name", "Type", "State", "Public IP", "Launch Time", "Region"]

def list_s3_buckets(session):
    s3 = session.client('s3')
    response = s3.list_buckets()
    buckets = [[bucket['Name'], bucket['CreationDate'], s3.meta.region_name] for bucket in response['Buckets']]
    return buckets, ["Bucket Name", "Creation Date", "Region"]

def list_lambda_functions(session):
    lambda_client = session.client('lambda')
    response = lambda_client.list_functions()
    functions = [[fn['FunctionName'], fn['Runtime'], fn['LastModified'], lambda_client.meta.region_name] for fn in response['Functions']]
    return functions, ["Function Name", "Runtime", "Last Modified", "Region"]

def list_rds_instances(session):
    rds = session.client('rds')
    response = rds.describe_db_instances()
    instances = [[db['DBInstanceIdentifier'], db['Engine'], db['DBInstanceStatus'], db['InstanceCreateTime'], rds.meta.region_name] for db in response['DBInstances']]
    return instances, ["DB Identifier", "Engine", "Status", "Creation Date", "Region"]

def list_iam_users(session):
    iam = session.client('iam')
    response = iam.list_users()
    users = [[user['UserName'], user['CreateDate'], iam.meta.region_name] for user in response['Users']]
    return users, ["User Name", "Created Date", "Region"]

def list_elasticache_clusters(session):
    elasticache = session.client('elasticache')
    response = elasticache.describe_cache_clusters()
    clusters = [[cluster['CacheClusterId'], cluster['Engine'], cluster['CacheClusterStatus'], cluster['CacheClusterCreateTime'], elasticache.meta.region_name] for cluster in response['CacheClusters']]
    return clusters, ["Cluster ID", "Engine", "Status", "Creation Date", "Region"]

def list_elb_load_balancers(session):
    elb = session.client('elbv2')
    response = elb.describe_load_balancers()
    load_balancers = [[lb['LoadBalancerName'], lb['Type'], lb['State']['Code'], lb['CreatedTime'], elb.meta.region_name] for lb in response['LoadBalancers']]
    return load_balancers, ["Load Balancer Name", "Type", "State", "Creation Date", "Region"]

def list_redshift_clusters(session):
    redshift = session.client('redshift')
    response = redshift.describe_clusters()
    clusters = [[cluster['ClusterIdentifier'], cluster['NodeType'], cluster['ClusterStatus'], cluster['ClusterCreateTime'], redshift.meta.region_name] for cluster in response['Clusters']]
    return clusters, ["Cluster Identifier", "Node Type", "Status", "Creation Date", "Region"]

def list_dynamodb_tables(session):
    dynamodb = session.client('dynamodb')
    response = dynamodb.list_tables()
    tables = [[table_name, dynamodb.meta.region_name] for table_name in response['TableNames']]
    return tables, ["Table Name", "Region"]

def list_efs_file_systems(session):
    efs = session.client('efs')
    response = efs.describe_file_systems()
    file_systems = [[fs['FileSystemId'], fs['CreationTime'], efs.meta.region_name] for fs in response['FileSystems']]
    return file_systems, ["File System ID", "Creation Date", "Region"]

def list_cloudfront_distributions(session):
    cloudfront = session.client('cloudfront')
    response = cloudfront.list_distributions()
    distributions = [[dist['Id'], dist['Status'], cloudfront.meta.region_name] for dist in response.get('DistributionList', {}).get('Items', [])]
    return distributions, ["Distribution ID", "Status", "Region"]

def main():
    parser = argparse.ArgumentParser(description="List AWS resources across multiple profiles.")
    parser.add_argument("-v", "--verbose", action="store_true", help="Show all resource types, even if no entries exist.")
    args = parser.parse_args()

    session = boto3.Session()
    profiles = session.available_profiles

    services = [
        ("EC2 Instances", list_ec2_instances),
        ("S3 Buckets", list_s3_buckets),
        ("Lambda Functions", list_lambda_functions),
        ("RDS Instances", list_rds_instances),
        ("IAM Users", list_iam_users),
        ("ElastiCache Clusters", list_elasticache_clusters),
        ("ELB Load Balancers", list_elb_load_balancers),
        ("Redshift Clusters", list_redshift_clusters),
        ("DynamoDB Tables", list_dynamodb_tables),
        ("EFS File Systems", list_efs_file_systems),
        ("CloudFront Distributions", list_cloudfront_distributions),
    ]

    for profile in profiles:
        separator_length = 120
        separator_char = "—"

        print("\n" + separator_char * separator_length)
        print(f"Profile: {profile} ")

        session = boto3.Session(profile_name=profile)
        for service_name, function in services:
            data, headers = function(session)
            if data or args.verbose:
                print(f"\n{service_name}")
                if data:
                    print(tabulate(data, headers=headers, tablefmt="mixed_outline"))
                else:
                    print("No resources found.")
        print(separator_char * separator_length + "\n")

if __name__ == "__main__":
    main()
