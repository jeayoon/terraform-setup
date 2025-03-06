{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullS3Access",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${s3_name}/*",
                "arn:aws:s3:::${s3_name}"
            ]
        }
    ]
}
