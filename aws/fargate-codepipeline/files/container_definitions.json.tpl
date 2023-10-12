[
    {
        "name": "${container_name}",
        "image": "${container_image}",
        "cpu": 256,
        "essential": true,
        "memory": 512,
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": ${container_port},
                "hostPort": ${container_port}
            }
        ],
        "LogConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${cloudwatch_log_group_name}",
                "awslogs-region": "ap-northeast-1",
                "awslogs-stream-prefix": "terraform"
            }
        }
    }
]