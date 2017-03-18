<!DOCTYPE html>
<html lang="en">
<?php
	require_once 'components/header.php';
?>
<?php
if (!empty($_GET['Full_Name'])) {
	$Full_Name=$_GET['Full_Name'];
	if (!empty($_GET['Phone'])) {
		$Phone=$_GET['Phone'];
		if (!empty($_GET['Email'])) {
			$Email=$_GET['Email'];
			if (!empty($_GET['Kindergarten'])) {
				$Kindergarten=$_GET['Kindergarten'];
				echo "Kindergarden Entry</br>";
			} else {
				$Kindergarten='0';
			}
			if (!empty($_GET['Grade1'])) {
				$Grade1=$_GET['Grade1'];
				echo "Grade 1 Entry</br>";
			} else {
				$Grade1='0';
			}
			if (!empty($_GET['Grade2'])) {
				$Grade2=$_GET['Grade2'];
				echo "Grade 2 Entry</br>";
			} else {
				$Grade2='0';
			}
			if (!empty($_GET['Grade3'])) {
				$Grade3=$_GET['Grade3'];
				echo "Grade 3 Entry</br>";
			} else {
				$Grade3='0';
			}
			if (!empty($_GET['Grade4'])) {
				$Grade4=$_GET['Grade4'];
				echo "Grade 4 Entry</br>";
			} else {
				$Grade4='0';
			}
			if (!empty($_GET['Grade5'])) {
				$Grade5=$_GET['Grade5'];
				echo "Grade 5 Entry</br>";
			} else {
				$Grade5='0';
			}
			include 'components/database.php';
			$sql = "insert into stats (Name,Phone,Email,Kindergarten,Grade1,Grade2,Grade3,Grade4,Grade5) VALUES ('$Full_Name','$Phone','$Email','$Kindergarten','$Grade1','$Grade2','$Grade3','$Grade4','$Grade5')";

			$pdo = Database::connect();
			$pdo->query($sql);
			Database::disconnect();
			
		}else {
			echo "You did not enter an email address</br>";
		}
	} else {
		echo "You did not enter a phone number!</br>";
	}
} else {
	echo "You did not Enter a Name!</br>";
}
	echo "Entry Info:</br>";
	echo "</br><b>$Full_Name</b>";
	echo "</br><b>$Phone</b>";
	echo "</br><b>$Email</b>";

	echo "</br><b>Thank You!</b>";
	header("Refresh:7 url=index.php");
	
?>

<?php
	require_once 'components/footer.php';
?>

</html>