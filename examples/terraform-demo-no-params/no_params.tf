locals {
  name_no_params = "example_NP_Audit"
  subscription_name_no_params = "example"
  management_group_no_params = ""
  enforcement_mode_no_params = false
  policy_ids_no_params = [
    # -----------------------------------------------------------------------------------------------------------------
    # API for FHIR
    # -----------------------------------------------------------------------------------------------------------------
    "051cba44-2429-45b9-9649-46cec11c7119", # Azure API for FHIR should use a customer-managed key to encrypt data at rest 
    "1ee56206-5dd1-42ab-b02d-8aae8b1634ce", # Azure API for FHIR should use private link 
    "0fea8f8a-4169-495d-8307-30ec335f387d", # CORS should not allow every domain to access your API for FHIR 
    
    # -----------------------------------------------------------------------------------------------------------------
    # App Configuration
    # -----------------------------------------------------------------------------------------------------------------
    "3d9f5e4c-9947-4579-9539-2a7695fbc187", # App Configuration should disable public network access 
    "89c8a434-18f0-402c-8147-630a8dea54e0", # App Configuration should use a SKU that supports private link 
    "967a4b4b-2da9-43c1-b7d0-f98d0d74d0b1", # App Configuration should use a customer-managed key 
    "ca610c1d-041c-4332-9d88-7ed3094967c7", # App Configuration should use private link 
    "b08ab3ca-1062-4db3-8803-eec9cae605d6", # App Configuration stores should have local authentication methods disabled 
    
    # -----------------------------------------------------------------------------------------------------------------
    # App Platform
    # -----------------------------------------------------------------------------------------------------------------
    "0f2d8593-4667-4932-acca-6a9f187af109", # Audit Azure Spring Cloud instances where distributed tracing is not enabled 
    
    # -----------------------------------------------------------------------------------------------------------------
    # App Service
    # -----------------------------------------------------------------------------------------------------------------
    "b7ddfbdc-1260-477d-91fd-98bd9be789a6", # API App should only be accessible over HTTPS 
    "324c7761-08db-4474-9661-d1039abc92ee", # API apps should use an Azure file share for its content directory 
    "d6545c6b-dd9d-4265-91e6-0b451e2f1c50", # App Service Environment should disable TLS 1.0 and 1.1 
    "fb74e86f-d351-4b8d-b034-93da7391c01f", # App Service Environment should enable internal encryption 
    "33228571-70a4-4fa1-8ca1-26d0aba8d6ef", # App Service apps should enable outbound non-RFC 1918 traffic to Azure Virtual Network 
    "d79ab062-dffd-4318-8344-f70de714c0bc", # App Service should disable public network access 
    "c4ebc54a-46e1-481a-bee2-d4411e95d828", # Authentication should be enabled on your API app 
    "c75248c1-ea1d-4a9c-8fc9-29a6aabd5da8", # Authentication should be enabled on your Function app 
    "95bccee9-a7f8-4bec-9ee9-62c3473701fc", # Authentication should be enabled on your web app 
    "358c20a6-3f9e-4f0e-97ff-c6ce485e2aac", # CORS should not allow every resource to access your API App 
    "0820b7b9-23aa-4725-a1ce-ae4558f718e5", # CORS should not allow every resource to access your Function Apps 
    "5744710e-cc2f-4ee8-8809-3b11e89f4bc9", # CORS should not allow every resource to access your Web Applications 
    "b607c5de-e7d9-4eee-9e5c-83f1bcee4fa0", # Diagnostic logs in App Services should be enabled 
    "0c192fe8-9cbb-4516-85b3-0ade8bd03886", # Ensure API app has 'Client Certificates (Incoming client certificates)' set to 'On' 
    "5bb220d9-2698-4ee4-8404-b9c30c9df609", # Ensure WEB app has 'Client Certificates (Incoming client certificates)' set to 'On' 
    "991310cd-e9f3-47bc-b7b6-f57b557d07db", # Ensure that 'HTTP Version' is the latest, if used to run the API app 
    "e2c1c086-2d84-4019-bff3-c44ccd95113c", # Ensure that 'HTTP Version' is the latest, if used to run the Function app 
    "8c122334-9d20-4eb8-89ea-ac9a705b74ae", # Ensure that 'HTTP Version' is the latest, if used to run the Web app 
    "9a1b8c48-453a-4044-86c3-d8bfd823e4f5", # FTPS only should be required in your API App 
    "399b2637-a50f-4f95-96f8-3a145476eb15", # FTPS only should be required in your Function App 
    "4d24b6d4-5e53-4a4f-a7f4-618fa573ee4b", # FTPS should be required in your Web App 
    "6d555dd1-86f2-4f1c-8ed7-5abae7c6cbab", # Function App should only be accessible over HTTPS 
    "eaebaea7-8013-4ceb-9d14-7eb32271373c", # Function apps should have 'Client Certificates (Incoming client certificates)' enabled 
    "4d0bc837-6eff-477e-9ecd-33bf8d4212a5", # Function apps should use an Azure file share for its content directory 
    "8cb6aa8b-9e41-4f4e-aa25-089a7ac2581e", # Latest TLS version should be used in your API App 
    "f9d614c5-c173-4d56-95a7-b4437057d193", # Latest TLS version should be used in your Function App 
    "f0e6e85b-9b9f-4a4b-b67b-f730d42f1b0b", # Latest TLS version should be used in your Web App 
    "c4d441f8-f9d9-4a9e-9cef-e82117cb3eef", # Managed identity should be used in your API App 
    "0da106f2-4ca3-48e8-bc85-c638fe6aea8f", # Managed identity should be used in your Function App 
    "2b9ad585-36bc-4615-b300-fd4435808332", # Managed identity should be used in your Web App 
    "e9c8d085-d9cc-4b17-9cdc-059f1f01f19e", # Remote debugging should be turned off for API Apps 
    "0e60b895-3786-45da-8377-9c6b4b6ac5f9", # Remote debugging should be turned off for Function Apps 
    "cb510bfd-1cba-4d9f-a230-cb0976f4bb71", # Remote debugging should be turned off for Web Applications 
    "a4af4a39-4135-47fb-b175-47fbdf85311d", # Web Application should only be accessible over HTTPS 
    "dcbc65aa-59f3-4239-8978-3bb869d82604", # Web apps should use an Azure file share for its content directory 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Attestation
    # -----------------------------------------------------------------------------------------------------------------
    "7b256a2d-058b-41f8-bed9-3f870541c40a", # Azure Attestation providers should use private endpoints 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Automation
    # -----------------------------------------------------------------------------------------------------------------
    "3657f5a0-770e-44a3-b44e-9431ba1e9735", # Automation account variables should be encrypted 
    "955a914f-bf86-4f0e-acd5-e0766b0efcb6", # Automation accounts should disable public network access 
    "56a5ee18-2ae6-4810-86f7-18e39ce5629b", # Azure Automation accounts should use customer-managed keys to encrypt data at rest 
    "0c2b3618-68a8-4034-a150-ff4abc873462", # Private endpoint connections on Automation Accounts should be enabled 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Azure Active Directory
    # -----------------------------------------------------------------------------------------------------------------
    "3aa87b5a-7813-4b57-8a43-42dd9df5aaa7", # Azure Active Directory Domain Services managed domains should use TLS 1.2 only mode 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Azure Data Explorer
    # -----------------------------------------------------------------------------------------------------------------
    "81e74cea-30fd-40d5-802f-d72103c2aaaa", # Azure Data Explorer encryption at rest should use a customer-managed key 
    "f4b53539-8df9-40e4-86c6-6b607703bd4e", # Disk encryption should be enabled on Azure Data Explorer 
    "ec068d99-e9c7-401f-8cef-5bdde4e6ccf1", # Double encryption should be enabled on Azure Data Explorer 
    "9ad2fd1f-b25f-47a2-aa01-1a5a779e6413", # Virtual network injection should be enabled for Azure Data Explorer 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Azure Stack Edge
    # -----------------------------------------------------------------------------------------------------------------
    "b4ac1030-89c5-4697-8e00-28b5ba6a8811", # Azure Stack Edge devices should use double-encryption 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Backup
    # -----------------------------------------------------------------------------------------------------------------
    "013e242c-8828-4970-87b3-ab247555486d", # Azure Backup should be enabled for Virtual Machines 
    "deeddb44-9f94-4903-9fa0-081d524406e3", # Azure Recovery Services vaults should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Batch
    # -----------------------------------------------------------------------------------------------------------------
    "99e9ccd8-3db9-4592-b0d1-14b1715a4d8a", # Azure Batch account should use customer-managed keys to encrypt data 
    "009a0c92-f5b4-4776-9b66-4ed2b4775563", # Private endpoint connections on Batch accounts should be enabled 
    "74c5a0ae-5e48-4738-b093-65e23a060488", # Public network access should be disabled for Batch accounts 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Bot Service
    # -----------------------------------------------------------------------------------------------------------------
    "6164527b-e1ee-4882-8673-572f425f5e0a", # Bot Service endpoint should be a valid HTTPS URI 
    "51522a96-0869-4791-82f3-981000c2c67f", # Bot Service should be encrypted with a customer-managed key 
    "52152f42-0dda-40d9-976e-abb1acdd611e", # Bot Service should have isolated mode enabled 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Cache
    # -----------------------------------------------------------------------------------------------------------------
    "470baccb-7e51-4549-8b1a-3e5be069f663", # Azure Cache for Redis should disable public network access 
    "7d092e0a-7acd-40d2-a975-dca21cae48c4", # Azure Cache for Redis should reside within a virtual network 
    "7803067c-7d34-46e3-8c79-0ca68fc4036d", # Azure Cache for Redis should use private link 
    "22bee202-a82f-4305-9a2a-6d7f44d4dedb", # Only secure connections to your Azure Cache for Redis should be enabled 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Cognitive Services
    # -----------------------------------------------------------------------------------------------------------------
    "0725b4dd-7e76-479c-a735-68e7ee23d5ca", # Cognitive Services accounts should disable public network access 
    "67121cc7-ff39-4ab8-b7e3-95b84dab487d", # Cognitive Services accounts should enable data encryption with a customer-managed key 
    "71ef260a-8f18-47b7-abcb-62d0673d94dc", # Cognitive Services accounts should have local authentication methods disabled 
    "037eea7a-bd0a-46c5-9a66-03aea78705d3", # Cognitive Services accounts should restrict network access 
    "fe3fd216-4f83-4fc1-8984-2bbec80a3418", # Cognitive Services accounts should use a managed identity 
    "46aa9b05-0e60-4eae-a88b-1e9d374fa515", # Cognitive Services accounts should use customer owned storage 
    "cddd188c-4b82-4c48-a19d-ddf74ee66a01", # Cognitive Services should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Compute
    # -----------------------------------------------------------------------------------------------------------------
    "06a78e20-9358-41c9-923c-fb736d382a4d", # Audit VMs that do not use managed disks 
    "0015ea4d-51ff-4ce3-8d8c-f3f8f0179a56", # Audit virtual machines without disaster recovery configured 
    "f39f5f49-4abf-44de-8c70-0756997bfb51", # Disk access resources should use private link 
    "ca91455f-eace-4f96-be59-e6e2c35b4816", # Managed disks should be double encrypted with both platform-managed and customer-managed keys 
    "8405fdab-1faf-48aa-b702-999c9c172094", # Managed disks should disable public network access 
    "c43e4a30-77cb-48ab-a4dd-93f175c63b57", # Microsoft Antimalware for Azure should be configured to automatically update protection signatures 
    "9b597639-28e4-48eb-b506-56b05d366257", # Microsoft IaaSAntimalware extension should be deployed on Windows servers 
    "702dd420-7fcc-42c5-afe8-4026edd20fe0", # OS and data disks should be encrypted with a customer-managed key 
    "465f0161-0087-490a-9ad9-ad6217f4f43a", # Require automatic OS image patching on Virtual Machine Scale Sets 
    "2c89a2e5-7285-40fe-afe0-ae8654b92fb2", # Unattached disks should be encrypted 
    "fc4d8e41-e223-45ea-9bf5-eada37891d87", # Virtual machines and virtual machine scale sets should have encryption at host enabled 
    "1d84d5fb-01f6-4d12-ba4f-4a26081d403d", # Virtual machines should be migrated to new Azure Resource Manager resources 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Container Instance
    # -----------------------------------------------------------------------------------------------------------------
    "8af8f826-edcb-4178-b35f-851ea6fea615", # Azure Container Instance container group should deploy into a virtual network 
    "0aa61e00-0a01-4a3c-9945-e93cffedf0e6", # Azure Container Instance container group should use customer-managed key for encryption 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Container Registry
    # -----------------------------------------------------------------------------------------------------------------
    "5b9159ae-1701-4a6f-9a7a-aa9c8ddd0580", # Container registries should be encrypted with a customer-managed key 
    "bd560fc0-3c69-498a-ae9f-aa8eb7de0e13", # Container registries should have SKUs that support Private Links 
    "dc921057-6b28-4fbe-9b83-f7bec05db6c2", # Container registries should have local authentication methods disabled. 
    "d0793b48-0edc-4296-a390-4c75d1bdfd71", # Container registries should not allow unrestricted network access 
    "e8eef0a8-67cf-4eb4-9386-14b0e78733d4", # Container registries should use private link 
    "0fdf0491-d080-4575-b627-ad0e843cba0f", # Public network access should be disabled for Container registries 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Cosmos DB
    # -----------------------------------------------------------------------------------------------------------------
    "862e97cf-49fc-4a5c-9de4-40d4e2e7c8eb", # Azure Cosmos DB accounts should have firewall rules 
    "1f905d99-2ab7-462c-a6b0-f709acca6c8f", # Azure Cosmos DB accounts should use customer-managed keys to encrypt data at rest 
    "797b37f7-06b8-444c-b1ad-fc62867f335a", # Azure Cosmos DB should disable public network access 
    "58440f8a-10c5-4151-bdce-dfbaad4a20b7", # CosmosDB accounts should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Data Factory
    # -----------------------------------------------------------------------------------------------------------------
    "127ef6d7-242f-43b3-9eef-947faf1725d0", # Azure Data Factory linked services should use Key Vault for storing secrets 
    "f78ccdb4-7bf4-4106-8647-270491d2978a", # Azure Data Factory linked services should use system-assigned managed identity authentication when it is supported 
    "77d40665-3120-4348-b539-3192ec808307", # Azure Data Factory should use a Git repository for source control 
    "8b0323be-cc25-4b61-935d-002c3798c6ea", # Azure Data Factory should use private link 
    "4ec52d6d-beb7-40c4-9a9e-fe753254690e", # Azure data factories should be encrypted with a customer-managed key 
    "1cf164be-6819-4a50-b8fa-4bcaa4f98fb6", # Public network access on Azure Data Factory should be disabled 
    "0088bc63-6dee-4a9c-9d29-91cfdc848952", # SQL Server Integration Services integration runtimes on Azure Data Factory should be joined to a virtual network 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Data Lake
    # -----------------------------------------------------------------------------------------------------------------
    "a7ff3161-0087-490a-9ad9-ad6217f4f43a", # Require encryption on Data Lake Store accounts 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Event Grid
    # -----------------------------------------------------------------------------------------------------------------
    "f8f774be-6aee-492a-9e29-486ef81f3a68", # Azure Event Grid domains should disable public network access 
    "9830b652-8523-49cc-b1b3-e17dce1127ca", # Azure Event Grid domains should use private link 
    "1adadefe-5f21-44f7-b931-a59b54ccdb45", # Azure Event Grid topics should disable public network access 
    "4b90e17e-8448-49db-875e-bd83fb6f804f", # Azure Event Grid topics should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Event Hub
    # -----------------------------------------------------------------------------------------------------------------
    "b278e460-7cfc-4451-8294-cccc40a940d7", # All authorization rules except RootManageSharedAccessKey should be removed from Event Hub namespace 
    "f4826e5f-6a27-407c-ae3e-9582eb39891d", # Authorization rules on the Event Hub instance should be defined 
    "a1ad735a-e96f-45d2-a7b2-9a4932cab7ec", # Event Hub namespaces should use a customer-managed key for encryption 
    "b8564268-eb4a-4337-89be-a19db070c59d", # Event Hub namespaces should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # General
    # -----------------------------------------------------------------------------------------------------------------
    "0a914e76-4921-4c19-b460-a2d36003525a", # Audit resource location matches resource group location 
    "a451c1ef-c6ca-483d-87ed-f49761e3ffb5", # Audit usage of custom RBAC rules 
    "10ee2ea2-fb4d-45b8-a7e9-a2e770044cd9", # Custom subscription owner roles should not exist 
    
    # -----------------------------------------------------------------------------------------------------------------
    # HDInsight
    # -----------------------------------------------------------------------------------------------------------------
    "b0ab5b05-1c98-40f7-bb9e-dc568e41b501", # Azure HDInsight clusters should be injected into a virtual network 
    "64d314f6-6062-4780-a861-c23e8951bee5", # Azure HDInsight clusters should use customer-managed keys to encrypt data at rest 
    "1fd32ebd-e4c3-4e13-a54a-d7422d4d95f6", # Azure HDInsight clusters should use encryption at host to encrypt data at rest 
    "d9da03a1-f3c3-412a-9709-947156872263", # Azure HDInsight clusters should use encryption in transit to encrypt communication between Azure HDInsight cluster nodes 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Internet of Things
    # -----------------------------------------------------------------------------------------------------------------
    "2d7e144b-159c-44fc-95c1-ac3dbf5e6e54", # Azure IoT Hub should use customer-managed key to encrypt data at rest 
    "47031206-ce96-41f8-861b-6a915f3de284", # IoT Hub device provisioning service data should be encrypted using customer-managed keys (CMK) 
    "d82101f3-f3ce-4fc5-8708-4c09f4009546", # IoT Hub device provisioning service instances should disable public network access 
    "df39c015-56a4-45de-b4a3-efe77bed320d", # IoT Hub device provisioning service instances should use private link 
    "0d40b058-9f95-4a19-93e3-9b0330baa2a3", # Private endpoint should be enabled for IoT Hub 
    "2d6830fb-07eb-48e7-8c4d-2a442b35f0fb", # Public network access on Azure IoT Hub should be disabled 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Key Vault
    # -----------------------------------------------------------------------------------------------------------------
    "c39ba22d-4428-4149-b981-70acb31fc383", # Azure Key Vault Managed HSM should have purge protection enabled 
    "55615ac9-af46-4a59-874e-391cc3dfb490", # Azure Key Vault should disable public network access 
    "a6abeaec-4d90-4a02-805f-6b26c4d3fbe9", # Azure Key Vaults should use private link 
    "152b15f7-8e1f-4c1f-ab71-8c010ba5dbc0", # Key Vault keys should have an expiration date 
    "98728c90-32c7-4049-8429-847dc0f4fe37", # Key Vault secrets should have an expiration date 
    "0b60c0b2-2dc2-4e1c-b5c9-abbed971de53", # Key vaults should have purge protection enabled 
    "1e66c121-a66a-4b1f-9b83-0fd99bf0fc2d", # Key vaults should have soft delete enabled 
    "587c79fe-dd04-4a5e-9d0b-f89598c7261b", # Keys should be backed by a hardware security module (HSM) 
    "5f0bc445-3935-4915-9981-011aa2b46147", # Private endpoint should be configured for Key Vault 
    "75262d3e-ba4a-4f43-85f8-9f72c090e5e3", # Secrets should have content type set 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Kubernetes
    # -----------------------------------------------------------------------------------------------------------------
    "8dfab9c4-fe7b-49ad-85e4-1e9be085358f", # Azure Arc enabled Kubernetes clusters should have Azure Defender's extension installed 
    "040732e8-d947-40b8-95d6-854c95024bf8", # Azure Kubernetes Service Private Clusters should be enabled 
    "0a15ec92-a229-4763-bb14-0ea34a568f8d", # Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters 
    "7d7be79c-23ba-4033-84dd-45e2a5ccdd67", # Both operating systems and data disks in Azure Kubernetes Service clusters should be encrypted by customer-managed keys 
    "41425d9f-d1a5-499a-9932-f8ed8453932c", # Temp disks and cache for agent node pools in Azure Kubernetes Service clusters should be encrypted at host 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Lighthouse
    # -----------------------------------------------------------------------------------------------------------------
    "76bed37b-484f-430f-a009-fd7592dff818", # Audit delegation of scopes to a managing tenant 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Logic Apps
    # -----------------------------------------------------------------------------------------------------------------
    "1fafeaf6-7927-4059-a50a-8eb2a7a6f2b5", # Logic Apps Integration Service Environment should be encrypted with customer-managed keys 
    "dc595cb1-1cde-45f6-8faf-f88874e1c0e1", # Logic Apps should be deployed into Integration Service Environment 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Machine Learning
    # -----------------------------------------------------------------------------------------------------------------
    "ba769a63-b8cc-4b2d-abf6-ac33c7204be8", # Azure Machine Learning workspaces should be encrypted with a customer-managed key 
    "40cec1dd-a100-4920-b15b-3024fe8901ab", # Azure Machine Learning workspaces should use private link 
    "5f0c7d88-c7de-45b8-ac49-db49e72eaa78", # Azure Machine Learning workspaces should use user-assigned managed identity 
    "e96a9a5f-07ca-471b-9bc5-6a0f33cbd68f", # Machine Learning computes should have local authentication methods disabled 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Managed Application
    # -----------------------------------------------------------------------------------------------------------------
    "9db7917b-1607-4e7d-a689-bca978dd0633", # Application definition for Managed Application should use customer provided storage account 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Media Services
    # -----------------------------------------------------------------------------------------------------------------
    "a77d8bb4-8d22-4bc1-a884-f582a705b480", # Azure Media Services accounts should use an API that supports Private Link 
    "ccf93279-9c91-4143-a841-8d1f21505455", # Azure Media Services accounts that allow access to the legacy v2 API should be blocked 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Monitoring
    # -----------------------------------------------------------------------------------------------------------------
    "b02aacc0-b073-424e-8298-42b22829ee0a", # Activity log should be retained for at least one year 
    "1bc02227-0cb6-4e11-8f53-eb0b22eab7e8", # Application Insights components should block log ingestion and querying from public networks 
    "94c1f94d-33b0-4062-bd04-1cdc3e7eece2", # Azure Log Search Alerts over Log Analytics workspaces should use customer-managed keys 
    "ea0dfaed-95fb-448c-934e-d6e713ce393d", # Azure Monitor Logs clusters should be created with infrastructure-encryption enabled (double encryption) 
    "1f68a601-6e6d-4e42-babf-3f643a047ea2", # Azure Monitor Logs clusters should be encrypted with customer-managed key 
    "d550e854-df1a-4de9-bf44-cd894b39a95e", # Azure Monitor Logs for Application Insights should be linked to a Log Analytics workspace 
    "1a4e592a-6a6e-44a5-9814-e36264ca96e7", # Azure Monitor log profile should collect logs for categories 'write,' 'delete,' and 'action' 
    "41388f1c-2db0-4c25-95b2-35d7f5ccbfa9", # Azure Monitor should collect activity logs from all regions 
    "3e596b57-105f-48a6-be97-03e9243bad6e", # Azure Monitor solution 'Security and Audit' must be deployed 
    "7796937f-307b-4598-941c-67d3a05ebfe7", # Azure subscriptions should have a log profile for Activity Log 
    "842c54e8-c2f9-4d79-ae8d-38d8b8019373", # Log Analytics agent should be installed on your Linux Azure Arc machines 
    "d69b1763-b96d-40b8-a2d9-ca31e9fd0d3e", # Log Analytics agent should be installed on your Windows Azure Arc machines 
    "6c53d030-cc64-46f0-906d-2bc061cd1334", # Log Analytics workspaces should block log ingestion and querying from public networks 
    "04c4380f-3fae-46e8-96c9-30193528f602", # Network traffic data collection agent should be installed on Linux virtual machines 
    "2f2ee1de-44aa-4762-b6bd-0893fc3f306d", # Network traffic data collection agent should be installed on Windows virtual machines 
    "fa298e57-9444-42ba-bf04-86e8470e32c7", # Saved-queries in Azure Monitor should be saved in customer storage account for logs encryption 
    "fbb99e8e-e444-4da0-9ff1-75c92f5a85b2", # Storage account containing the container with activity logs must be encrypted with BYOK 
    "efbde977-ba53-4479-b8e9-10b957924fbf", # The Log Analytics agent should be installed on Virtual Machine Scale Sets 
    "a70ca396-0a34-413a-88e1-b956c1e683be", # The Log Analytics agent should be installed on virtual machines 
    "6fc8115b-2008-441f-8c61-9b722c1e537f", # Workbooks should be saved to storage accounts that you control 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Network
    # -----------------------------------------------------------------------------------------------------------------
    "fc5e4038-4584-4632-8c85-c0448d374b2c", # All Internet traffic should be routed via your deployed Azure Firewall 
    "e345b6c3-24bd-4c93-9bbb-7e5e49a17b78", # Azure VPN gateways should not use 'basic' SKU 
    "c251913d-7d24-4958-af87-478ed3b9ba41", # Flow logs should be configured for every network security group 
    "27960feb-a23c-4577-8d36-ef8b5f35e0be", # Flow logs should be enabled for every network security group 
    "35f9c03a-cc27-418e-9c0c-539ff999d010", # Gateway subnets should not be configured with a network security group 
    "2f080164-9f4d-497e-9db6-416dc9f7b48a", # Network Watcher flow logs should have traffic analytics enabled 
    "88c0b9da-ce96-4b03-9635-f29a937e2900", # Network interfaces should disable IP forwarding 
    "83a86a26-fd1f-447c-b59d-e51f44264114", # Network interfaces should not have public IPs 
    "e372f825-a257-4fb8-9175-797a8a8627d6", # RDP access from the Internet should be blocked 
    "2c89a2e5-7285-40fe-afe0-ae8654b92fab", # SSH access from the Internet should be blocked 
    "564feb30-bf6a-4854-b4bb-0d2d2d1e6c66", # Web Application Firewall (WAF) should be enabled for Application Gateway 
    "055aa869-bc98-4af8-bafc-23f1ab6ffe2c", # Web Application Firewall (WAF) should be enabled for Azure Front Door Service service 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Portal
    # -----------------------------------------------------------------------------------------------------------------
    "04c655fe-0ac7-48ae-9a32-3a2e208c7624", # Shared dashboards should not have markdown tiles with inline content 
    
    # -----------------------------------------------------------------------------------------------------------------
    # SQL
    # -----------------------------------------------------------------------------------------------------------------
    "1f314764-cb73-4fc9-b863-8eca98ac36e9", # An Azure Active Directory administrator should be provisioned for SQL servers 
    "abfb4388-5bf4-4ad7-ba82-2cd2f41ceae9", # Azure Defender for SQL should be enabled for unprotected Azure SQL servers 
    "abfb7388-5bf4-4ad7-ba99-2cd2f41cebb9", # Azure Defender for SQL should be enabled for unprotected SQL Managed Instances 
    "32e6bbec-16b6-44c2-be37-c5b672d103cf", # Azure SQL Database should have the minimal TLS version of 1.2 
    "5345bb39-67dc-4960-a1bf-427e16b9a0bd", # Connection throttling should be enabled for PostgreSQL database servers 
    "eb6f77b9-bd53-4e35-a23d-7f65d5f0e446", # Disconnections should be logged for PostgreSQL database servers. 
    "e802a67a-daf5-4436-9ea6-f6d821dd0c5d", # Enforce SSL connection should be enabled for MySQL database servers 
    "d158790f-bfb0-486c-8631-2dc6b4e8e6af", # Enforce SSL connection should be enabled for PostgreSQL database servers 
    "0ec47710-77ff-4a3d-9181-6aa50af424d0", # Geo-redundant backup should be enabled for Azure Database for MariaDB 
    "82339799-d096-41ae-8538-b108becf0970", # Geo-redundant backup should be enabled for Azure Database for MySQL 
    "48af4db5-9b8b-401c-8e74-076be876a430", # Geo-redundant backup should be enabled for Azure Database for PostgreSQL 
    "3a58212a-c829-4f13-9872-6371df2fd0b4", # Infrastructure encryption should be enabled for Azure Database for MySQL servers 
    "24fba194-95d6-48c0-aea7-f65bf859c598", # Infrastructure encryption should be enabled for Azure Database for PostgreSQL servers 
    "eb6f77b9-bd53-4e35-a23d-7f65d5f0e43d", # Log checkpoints should be enabled for PostgreSQL database servers 
    "eb6f77b9-bd53-4e35-a23d-7f65d5f0e442", # Log connections should be enabled for PostgreSQL database servers 
    "eb6f77b9-bd53-4e35-a23d-7f65d5f0e8f3", # Log duration should be enabled for PostgreSQL database servers 
    "d38fc420-0735-4ef3-ac11-c806f651a570", # Long-term geo-redundant backup should be enabled for Azure SQL Databases 
    "83cef61d-dbd1-4b20-a4fc-5fbc7da10833", # MySQL servers should use customer-managed keys to encrypt data at rest 
    "18adea5e-f416-4d0f-8aa8-d24321e3e274", # PostgreSQL servers should use customer-managed keys to encrypt data at rest 
    "7698e800-9299-47a6-b3b6-5a0fee576eed", # Private endpoint connections on Azure SQL Database should be enabled 
    "0a1302fb-a631-4106-9753-f3d494733990", # Private endpoint should be enabled for MariaDB servers 
    "7595c971-233d-4bcf-bd18-596129188c49", # Private endpoint should be enabled for MySQL servers 
    "0564d078-92f5-4f97-8398-b9f58a51f70b", # Private endpoint should be enabled for PostgreSQL servers 
    "1b8ca024-1d5c-4dec-8995-b1a932b41780", # Public network access on Azure SQL Database should be disabled 
    "fdccbe47-f3e3-4213-ad5d-ea459b2fa077", # Public network access should be disabled for MariaDB servers 
    "c9299215-ae47-4f50-9c54-8a392f68a052", # Public network access should be disabled for MySQL flexible servers 
    "d9844e8a-1437-4aeb-a32c-0c992f056095", # Public network access should be disabled for MySQL servers 
    "5e1de0e3-42cb-4ebc-a86d-61d0c619ca48", # Public network access should be disabled for PostgreSQL flexible servers 
    "b52376f7-9612-48a1-81cd-1ffe4b61032c", # Public network access should be disabled for PostgreSQL servers 
    "7ff426e2-515f-405a-91c8-4f2333442eb5", # SQL Auditing settings should have Action-Groups configured to capture critical activities 
    "b219b9cf-f672-4f96-9ab0-f5a3ac5e1c13", # SQL Database should avoid using GRS backup redundancy 
    "a8793640-60f7-487c-b5c3-1d37215905c4", # SQL Managed Instance should have the minimal TLS version of 1.2 
    "a9934fd7-29f2-4e6d-ab3d-607ea38e9079", # SQL Managed Instances should avoid using GRS backup redundancy 
    "048248b0-55cd-46da-b1ff-39efd52db260", # SQL managed instances should use customer-managed keys to encrypt data at rest 
    "0d134df8-db83-46fb-ad72-fe0c9428c8dd", # SQL servers should use customer-managed keys to encrypt data at rest 
    "89099bee-89e0-4b26-a5f4-165451757743", # SQL servers with auditing to storage account destination should be configured with 90 days retention or higher 
    "17k78e20-9358-41c9-923c-fb736d382a12", # Transparent Data Encryption on SQL databases should be enabled 
    "057d6cfe-9c4f-4a6d-bc60-14420ea1f1a9", # Vulnerability Assessment settings for SQL server should contain an email address to receive scan reports 
    "1b7aa243-30e4-4c9e-bca8-d0d3022b634a", # Vulnerability assessment should be enabled on SQL Managed Instance 
    "ef2a8f2a-b3d9-49cd-a8a8-9a3aaaf647d9", # Vulnerability assessment should be enabled on your SQL servers 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Search
    # -----------------------------------------------------------------------------------------------------------------
    "a049bf77-880b-470f-ba6d-9f21c530cf83", # Azure Cognitive Search service should use a SKU that supports private link 
    "ee980b6d-0eca-4501-8d54-f6290fd512c3", # Azure Cognitive Search services should disable public network access 
    "0fda3595-9f2b-4592-8675-4231d6fa82fe", # Azure Cognitive Search services should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Security Center
    # -----------------------------------------------------------------------------------------------------------------
    "4f11b553-d42e-4e3a-89be-32ca364cad4c", # A maximum of 3 owners should be designated for your subscription 
    "501541f7-f7e7-4cd6-868c-4190fdad3ac9", # A vulnerability assessment solution should be enabled on your virtual machines 
    "47a6b606-51aa-4496-8bb7-64b11cf66adc", # Adaptive application controls for defining safe applications should be enabled on your machines 
    "08e6af2d-db70-460a-bfe9-d5bd474ba9d6", # Adaptive network hardening recommendations should be applied on internet facing virtual machines 
    "9daedab3-fb2d-461e-b861-71790eead4f6", # All network ports should be restricted on network security groups associated to your virtual machine 
    "123a3936-f020-408a-ba0c-47873faf1534", # Allowlist rules in your adaptive application control policy should be updated 
    "0e246bcf-5f6f-4f87-bc6f-775d4712c7ea", # Authorized IP ranges should be defined on Kubernetes Services 
    "475aae12-b88a-4572-8b36-9b712b2b3a17", # Auto provisioning of the Log Analytics agent should be enabled on your subscription 
    "a7aca53f-2ed4-4466-a25e-0b45ade68efd", # Azure DDoS Protection Standard should be enabled 
    "2913021d-f2fd-4f3d-b958-22354e2bdbcb", # Azure Defender for App Service should be enabled 
    "7fe3b40f-802b-4cdd-8bd4-fd799c948cc2", # Azure Defender for Azure SQL Database servers should be enabled 
    "bdc59948-5574-49b3-bb91-76b7c986428d", # Azure Defender for DNS should be enabled 
    "0e6763cc-5078-4e64-889d-ff4d9a839047", # Azure Defender for Key Vault should be enabled 
    "523b5cd1-3e23-492f-a539-13118b6d1e3a", # Azure Defender for Kubernetes should be enabled 
    "c3d20c29-b36d-48fe-808b-99a87530ad99", # Azure Defender for Resource Manager should be enabled 
    "6581d072-105e-4418-827f-bd446d56421b", # Azure Defender for SQL servers on machines should be enabled 
    "308fbb08-4ab8-4e67-9b29-592e93fb94fa", # Azure Defender for Storage should be enabled 
    "c25d9a16-bc35-4e15-a7e5-9db606bf9ed4", # Azure Defender for container registries should be enabled 
    "4da35fc9-c9e7-4960-aec9-797fe7d9051d", # Azure Defender for servers should be enabled 
    "a0c11ca4-5828-4384-a2f2-fd7444dd5b4d", # Cloud Services (extended support) role instances should be configured securely 
    "1e378679-f122-4a96-a739-a7729c46e1aa", # Cloud Services (extended support) role instances should have an endpoint protection solution installed 
    "4df26ba8-026d-45b0-9521-bffa44d741d2", # Cloud Services (extended support) role instances should have system updates installed 
    "6b1cbf55-e8b6-442f-ba4c-7246b6381474", # Deprecated accounts should be removed from your subscription 
    "ebb62a0c-3560-49e1-89ed-27e074e9f8ad", # Deprecated accounts with owner permissions should be removed from your subscription 
    "0961003e-5a0a-4549-abde-af6a37f2724d", # Disk encryption should be applied on virtual machines 
    "6e2593d9-add6-4083-9c9b-4b7d2188c899", # Email notification for high severity alerts should be enabled 
    "0b15565f-aa9e-48ba-8619-45960f2c314d", # Email notification to subscription owner for high severity alerts should be enabled 
    "26a828e1-e88f-464e-bbb3-c134a282b9de", # Endpoint protection solution should be installed on virtual machine scale sets 
    "f8456c1c-aa66-4dfb-861a-25d127b775c9", # External accounts with owner permissions should be removed from your subscription 
    "5f76cf89-fbf2-47fd-a3f4-b891fa780b60", # External accounts with read permissions should be removed from your subscription 
    "5c607a2e-c700-4744-8254-d77e7c9eb5e4", # External accounts with write permissions should be removed from your subscription 
    "672fe5a1-2fcd-42d7-b85d-902b6e28c6ff", # Guest Attestation extension should be installed on supported Linux virtual machines 
    "a21f8c92-9e22-4f09-b759-50500d1d2dda", # Guest Attestation extension should be installed on supported Linux virtual machines scale sets 
    "1cb4d9c2-f88f-4069-bee0-dba239a57b09", # Guest Attestation extension should be installed on supported Windows virtual machines 
    "f655e522-adff-494d-95c2-52d4f6d56a42", # Guest Attestation extension should be installed on supported Windows virtual machines scale sets 
    "ae89ebca-1c92-4898-ac2c-9f63decb045c", # Guest Configuration extension should be installed on your machines 
    "bd352bd5-2853-4985-bf0d-73806b4a5744", # IP Forwarding on your virtual machine should be disabled 
    "f6de0be7-9a8a-4b8a-b349-43cf02d22f7c", # Internet-facing virtual machines should be protected with network security groups 
    "fb893a29-21bb-418c-a157-e99480ec364c", # Kubernetes Services should be upgraded to a non-vulnerable Kubernetes version 
    "b1bb3592-47b8-4150-8db0-bfdcc2c8965b", # Linux virtual machines should use Secure Boot 
    "d62cfe2b-3ab0-4d41-980d-76803b58ca65", # Log Analytics agent health issues should be resolved on your machines 
    "15fdbc87-8a47-4ee9-a2aa-9a2ea1f37554", # Log Analytics agent should be installed on your Cloud Services (extended support) role instances 
    "a4fe33eb-e377-4efb-ab31-0784311bc499", # Log Analytics agent should be installed on your virtual machine for Azure Security Center monitoring 
    "a3a6ea0c-e018-4933-9ef0-5aaa1501449b", # Log Analytics agent should be installed on your virtual machine scale sets for Azure Security Center monitoring 
    "9297c21d-2ed6-4474-b48f-163f75654ce3", # MFA should be enabled accounts with write permissions on your subscription 
    "aa633080-8b72-40c4-a2d7-d00c03e80bed", # MFA should be enabled on accounts with owner permissions on your subscription 
    "e3576e28-8b17-4677-84c3-db2990658d64", # MFA should be enabled on accounts with read permissions on your subscription 
    "b0f33259-77d7-4c9e-aac6-3aabcfae693c", # Management ports of virtual machines should be protected with just-in-time network access control 
    "22730e10-96f6-4aac-ad84-9383d35b5917", # Management ports should be closed on your virtual machines 
    "af6cd1bd-1635-48cb-bde7-5b15693900b9", # Monitor missing Endpoint Protection in Azure Security Center 
    "bb91dfba-c30d-4263-9add-9c2384e659a6", # Non-internet-facing virtual machines should be protected with network security groups 
    "ac4a19c2-fa67-49b4-8ae5-0b2e78c49457", # Role-Based Access Control (RBAC) should be used on Kubernetes Services 
    "feedbf84-6b99-488c-acc2-71c829aa5ffc", # SQL databases should have vulnerability findings resolved 
    "6ba6d016-e7c3-4842-b8f2-4992ebc0d72d", # SQL servers on machines should have vulnerability findings resolved 
    "97566dd7-78ae-4997-8b36-1c7bfe0d8121", # Secure Boot should be enabled on supported Windows virtual machines 
    "a1181c5f-672a-477a-979a-7d58aa086233", # Security Center standard pricing tier should be selected 
    "cc9835f2-9f6b-4cc8-ab4a-f8ef615eb349", # Sensitive data in your SQL databases should be classified 
    "6646a0bd-e110-40ca-bb97-84fcee63c414", # Service principals should be used to protect your subscriptions instead of management certificates 
    "e71308d3-144b-4262-b144-efdc3cc90517", # Subnets should be associated with a Network Security Group 
    "4f4f78b8-e367-4b10-a341-d9a4ad5cf1c7", # Subscriptions should have a contact email address for security issues 
    "c3f317a7-a95c-4547-b7e7-11017ebdf2fe", # System updates on virtual machine scale sets should be installed 
    "86b3d65f-7626-441e-b690-81a8b71cff60", # System updates should be installed on your machines 
    "09024ccc-0c5f-475e-9457-b7c0d9ed487b", # There should be more than one owner assigned to your subscription 
    "f6358610-e532-4236-b178-4c65865eb262", # Virtual machines guest attestation status should be healthy 
    "d26f7642-7545-4e18-9b75-8c9bbdee3a9a", # Virtual machines' Guest Configuration extension should be deployed with system-assigned managed identity 
    "5f0f936f-2f01-4bf5-b6be-d423792fa562", # Vulnerabilities in Azure Container Registry images should be remediated 
    "e8cbc669-f12d-49eb-93e7-9273119e9933", # Vulnerabilities in container security configurations should be remediated 
    "e1e5fd5d-3e4c-4ce1-8661-7d1873ae6b15", # Vulnerabilities in security configuration on your machines should be remediated 
    "3c735d8a-a4ba-4a3a-b7cf-db7754cf57f4", # Vulnerabilities in security configuration on your virtual machine scale sets should be remediated 
    "1c30f9cd-b84c-49cc-aa2c-9288447cc3b3", # vTPM should be enabled on supported virtual machines 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Service Bus
    # -----------------------------------------------------------------------------------------------------------------
    "a1817ec0-a368-432a-8057-8371e17ac6ee", # All authorization rules except RootManageSharedAccessKey should be removed from Service Bus namespace 
    "1c06e275-d63d-4540-b761-71f364c2111d", # Azure Service Bus namespaces should use private link 
    "295fc8b1-dc9f-4f53-9c61-3f313ceab40a", # Service Bus Premium namespaces should use a customer-managed key for encryption 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Service Fabric
    # -----------------------------------------------------------------------------------------------------------------
    "617c02be-7f02-4efd-8836-3180d47b6c68", # Service Fabric clusters should have the ClusterProtectionLevel property set to EncryptAndSign 
    "b54ed75b-3e1a-44ac-a333-05ba39b99ff0", # Service Fabric clusters should only use Azure Active Directory for client authentication 
    
    # -----------------------------------------------------------------------------------------------------------------
    # SignalR
    # -----------------------------------------------------------------------------------------------------------------
    "21a9766a-82a5-4747-abb5-650b6dbba6d0", # Azure SignalR Service should disable public network access 
    "464a1620-21b5-448d-8ce6-d4ac6d1bc49a", # Azure SignalR Service should use a Private Link enabled SKU 
    "53503636-bcc9-4748-9663-5348217f160f", # Azure SignalR Service should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Site Recovery
    # -----------------------------------------------------------------------------------------------------------------
    "11e3da8c-1d68-4392-badd-0ff3c43ab5b0", # Recovery Services vaults should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Storage
    # -----------------------------------------------------------------------------------------------------------------
    "1d320205-c6a1-4ac6-873d-46224024e8e2", # Azure File Sync should use private link 
    "bf045164-79ba-4215-8f95-f8048dc1780b", # Geo-redundant storage should be enabled for Storage Accounts 
    "970f84d8-71b6-4091-9979-ace7e3fb6dbb", # HPC Cache accounts should use customer-managed key for encryption 
    "21a8cd35-125e-4d13-b82d-2e19b7208bb7", # Public network access should be disabled for Azure File Sync 
    "404c3081-a854-4457-ae30-26a93ef643f9", # Secure transfer to storage accounts should be enabled 
    "b5ec538c-daa0-4006-8596-35468b9148e8", # Storage account encryption scopes should use customer-managed keys to encrypt data at rest 
    "044985bb-afe1-42cd-8a36-9d5d42424537", # Storage account keys should not be expired 
    "4fa4b6c0-31ca-4c0d-b10d-24b96f62a751", # Storage account public access should be disallowed 
    "c9d007d0-c057-4772-b18c-01e546713bcd", # Storage accounts should allow access from trusted Microsoft services 
    "37e0d2fe-28a5-43d6-a273-67d37d1f5606", # Storage accounts should be migrated to new Azure Resource Manager resources 
    "4733ea7b-a883-42fe-8cac-97454c2a9e4a", # Storage accounts should have infrastructure encryption 
    "34c877ad-507e-4c82-993e-3452a6e0ad3c", # Storage accounts should restrict network access 
    "2a1a9cdf-e04d-429a-8416-3bfb72a1b26f", # Storage accounts should restrict network access using virtual network rules 
    "6fac406b-40ca-413b-bf8e-0bf964659c25", # Storage accounts should use customer-managed key for encryption 
    "6edd7eda-6dd8-40f7-810d-67160c639cd9", # Storage accounts should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Stream Analytics
    # -----------------------------------------------------------------------------------------------------------------
    "87ba29ef-1ab3-4d82-b763-87fcd4f531f7", # Azure Stream Analytics jobs should use customer-managed keys to encrypt data 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Synapse
    # -----------------------------------------------------------------------------------------------------------------
    "3484ce98-c0c5-4c83-994b-c5ac24785218", # Azure Synapse workspaces should allow outbound data traffic only to approved targets 
    "38d8df46-cf4e-4073-8e03-48c24b29de0d", # Azure Synapse workspaces should disable public network access 
    "f7d52b2d-e161-4dfa-a82b-55e564167385", # Azure Synapse workspaces should use customer-managed keys to encrypt data at rest 
    "72d11df1-dd8a-41f7-8925-b05b960ebafc", # Azure Synapse workspaces should use private link 
    "56fd377d-098c-4f02-8406-81eb055902b8", # IP firewall rules on Azure Synapse workspaces should be removed 
    "2d9dbfa3-927b-4cf0-9d0f-08747f971650", # Managed workspace virtual network on Azure Synapse workspaces should be enabled 
    "2b18f286-371e-4b80-9887-04759970c0d3", # Synapse workspace auditing settings should have action groups configured to capture critical activities 
    "529ea018-6afc-4ed4-95bd-7c9ee47b00bc", # Synapse workspaces with SQL auditing to storage account destination should be configured with 90 days retention or higher 
    "0049a6b3-a662-4f3e-8635-39cf44ace45a", # Vulnerability assessment should be enabled on your Synapse workspaces 
    
    # -----------------------------------------------------------------------------------------------------------------
    # VM Image Builder
    # -----------------------------------------------------------------------------------------------------------------
    "2154edb9-244f-4741-9970-660785bccdaa", # VM Image Builder templates should use private link 
    
    # -----------------------------------------------------------------------------------------------------------------
    # Web PubSub
    # -----------------------------------------------------------------------------------------------------------------
    "bf45113f-264e-4a87-88f9-29ac8a0aca6a", # Azure Web PubSub Service should disable public network access 
    "82909236-25f3-46a6-841c-fe1020f95ae1", # Azure Web PubSub Service should use a SKU that supports private link 
    "52630df9-ca7e-442b-853b-c6ce548b31a2", # Azure Web PubSub Service should use private link 
    
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy name lookups:
# Because the policies are built-in, we can just look up their IDs by their names.
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_policy_definition" "no_params" {
  count        = length(local.policy_ids_no_params)
  name         = element(local.policy_ids_no_params, count.index)
}

locals {
  no_params_policy_definitions = flatten([tolist([
    for definition in data.azurerm_policy_definition.no_params.*.id :
    map("policyDefinitionId", definition)
    ])
  ])
}

# ---------------------------------------------------------------------------------------------------------------------
# Conditional data lookups: If the user supplies management group, look up the ID of the management group
# ---------------------------------------------------------------------------------------------------------------------
data "azurerm_management_group" "no_params" {
  count = local.management_group_no_params != "" ? 1 : 0
  display_name  = local.management_group_no_params
}

### If the user supplies subscription, look up the ID of the subscription
data "azurerm_subscriptions" "no_params" {
  count                 = local.subscription_name_no_params != "" ? 1 : 0
  display_name_contains = local.subscription_name_no_params
}

locals {
  no_params_scope = local.management_group_no_params != "" ? data.azurerm_management_group.no_params[0].id : element(data.azurerm_subscriptions.no_params[0].subscriptions.*.id, 0)
}

# ---------------------------------------------------------------------------------------------------------------------
# Policy Initiative
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_set_definition" "no_params" {
  name                  = local.name_no_params
  policy_type           = "Custom"
  display_name          = local.name_no_params
  description           = local.name_no_params
  management_group_name = local.management_group_no_params == "" ? null : local.management_group_no_params
  policy_definitions    = tostring(jsonencode(local.no_params_policy_definitions))
  metadata = tostring(jsonencode({
    category = local.name_no_params
  }))
}

# ---------------------------------------------------------------------------------------------------------------------
# Azure Policy Assignments
# Apply the Policy Initiative to the specified scope
# ---------------------------------------------------------------------------------------------------------------------
resource "azurerm_policy_assignment" "no_params" {
  name                 = local.name_no_params
  policy_definition_id = azurerm_policy_set_definition.no_params.id
  scope                = local.no_params_scope
  enforcement_mode     = local.enforcement_mode_no_params
}

# ---------------------------------------------------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------------------------------------------------
output "no_params_policy_assignment_ids" {
  value       = azurerm_policy_assignment.no_params.id
  description = "The IDs of the Policy Assignments."
}

output "no_params_scope" {
  value       = local.no_params_scope
  description = "The target scope - either the management group or subscription, depending on which parameters were supplied"
}

output "no_params_policy_set_definition_id" {
  value       = azurerm_policy_set_definition.no_params.id
  description = "The ID of the Policy Set Definition."
}

output "no_params_count_of_policies_applied" {
  description = "The number of Policies applied as part of the Policy Initiative"
  value       = length(local.policy_ids_no_params)
}