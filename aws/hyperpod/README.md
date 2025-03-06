# Hyerpod Terraform

## 概要

[Amazon SageMaker HyperPod](https://aws.amazon.com/jp/sagemaker-ai/hyperpod/)は、
AWS SageMaker HyperPodは、大規模言語モデルや生成AIモデルのトレーニング向けに設計された高性能クラスターサービスです。数千GPUへのスケーラビリティ、自動障害検出・回復機能により長時間トレーニングの信頼性を高め、事前最適化されたMLインフラで開発効率を向上させます。大規模AIモデル開発において、コスト効率と安定性を両立させる理想的なインフラストラクチャソリューションです。

以下は、今回構築するAWS Architectureです。
SageMaker HyperPodの構築にはAWS提供のLifeCycleを活用し、基盤となるインフラ部分はTerraformを用いて構築します。

<img width="662" alt="Image" src="https://github.com/user-attachments/assets/545f6fd7-d9fe-4481-a101-de8589dd56cf" />


