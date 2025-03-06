{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:StartSession",
                "ssm:TerminateSession",
                "sagemaker:DescribeCluster",
                "sagemaker:ListClusterNodes"
            ],
            "Resource": "*"
        }
    ]
}