resource "aws_resourcegroups_group" "k8s_demo_resources_s3_" {
  name = "k8s-demo-resources"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::S3::Bucket",
    "AWS::EKS::Cluster",
    "AWS::ECR::Repository",
    "AWS::EC2::VPC",
    "AWS::EC2::Subnet",
    "AWS::EC2::RouteTable",
    "AWS::EC2::NetworkAcl",
    "AWS::EC2::SecurityGroup",
    "AWS::EC2::NatGateway",
    "AWS::EC2::EIP",
    "AWS::EC2::InternetGateway"
  ],
  "TagFilters": [
    {
      "Key": "Environment",
      "Values": ["Demo"]
    }
  ]
}
JSON
  }

  tags = {
    Name        = "Resources for k8s"
    Environment = "Demo"
  }

}