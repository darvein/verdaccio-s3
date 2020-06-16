import os
import boto3

ec2 = boto3.client('ec2')
s3  = boto3.resource('s3')

INSTANCE_NAME = os.environ['PROJECT_NAME']
INSTANCE_TYPE = os.environ['VERDACCIO_EC2_INSTANCE_TYPE']
BUCKET_NAME   = os.environ['VERDACCIO_S3_BUCKET']


def test_verify_ec2():
    r = ec2.describe_instances(
            Filters=[{'Name': 'tag:Name', 'Values': ['{}'.format(INSTANCE_NAME)]}]
            )
    instanceType = r['Reservations'][0]['Instances'][0]['InstanceType']
    assert instanceType == INSTANCE_TYPE


def test_verify_s3():
    bucketName = s3.Bucket('{}'.format(BUCKET_NAME)).name
    assert BUCKET_NAME == bucketName
