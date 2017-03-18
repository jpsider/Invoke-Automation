use XesterUI;

INSERT INTO X_STATUS (ID, Status, HtmlColor, HTML_Description)
VALUES (1,'Down','#CC0000','Red'),
(2,'Up','#006633','Green'),
(3,'Starting Up','#FFFF00','Yellow'),
(4,'Shutting Down','#FF6600','Orange'),
(5,'Submitted','#666666','Grey'),
(6,'Queued','#FFFFFF','White'),
(7,'Assigned','#6699FF','SkyBlue'),
(8,'Running','#0066FF','Blue'),
(9,'Complete','#00CC66','LightGreen'),
(10,'Cancelled','#333333','Charcoal'),
(11,'Enabled','#006633','Green'),
(12,'Disabled','#CC0000','Red');

INSERT INTO X_RESULT (ID, Name, HtmlColor, HTML_Description)
VALUES (1,'PASS','#006633','Green'),
(2,'FAIL','#CC0000','Red'),
(3,'CRITICAL','#FFFF00','Yellow'),
(4,'AGENT_ERROR','#9933FF','Purple'),
(5,'ABORTED','#FF6600','Orange'),
(6,'UNKNOWN','#666666','Grey');

INSERT INTO QUEUE_MANAGER (Status_ID, Wait, Log_File)
VALUES (1,60,'c:\\XesterUI\\Queue_Manager\\Queue_Manager.log');

INSERT INTO TESTRUN_MANAGER (Status_ID, Wait, Max_Concurrent, Log_File)
VALUES (1,60,4,'c:\\XesterUI\\TESTRUN_Manager\\TESTRUN_Manager.log');

INSERT INTO PASSWORDS (ID, Username, Password)
VALUES (1,'administrator@corp.local','VMware1!'),(2,'administrator','BelayTech2015'),(3,'root','BelayTech2015');

INSERT INTO Target_Types (ID, Name)
VALUES (1,'vcenter'),(2,'DataCenter'),(3,'Cluster'),(4,'VM'),(5,'vds'),(6,'Host');

INSERT INTO SYSTEMS (ID,SYSTEM_Name,Config_File,STATUS_ID)
VALUES (1,'HomeLab','C:\Program Files\WindowsPowerShell\Modules\Vester\1.0.1\Configs\Config.json',11);

INSERT INTO TARGETS (ID,Target_Name,Target_Type_ID,IP_Address,STATUS_ID,Password_ID,System_ID)
VALUES (1,'192.168.2.200',1,'192.168.2.200',11,1,1),(2,'DC01',2,'na',11,1,1),(3,'Cluster01',3,'na',11,1,1),(4,'Win_7_test_VM',4,'na',11,2,1),(5,'Win_10_test_VM',4,'na',11,2,1),
(6,'CentOS_6_test_vm',4,'na',11,3,1),(7,'Android_4_test_vm',4,'na',11,1,1),(8,'Embedded-vCenter-Server-Appliance',4,'na',11,3,1),(9,'192.168.2.202',6,'192.168.2.202',11,1,1);



























