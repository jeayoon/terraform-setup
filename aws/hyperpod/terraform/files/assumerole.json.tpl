{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "${resource}.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}