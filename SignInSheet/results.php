<!DOCTYPE html>
<html lang="en">
<?php
	require_once 'components/header.php';
?>
<script> 
	$(document).ready(function() {
		$('#example').dataTable( {
			"order":[[ 0, "asc" ]]
		});
	});
</script>
<body>
    <div class="container" style="margin-left:10px">
    	<div class="row">
			<?php
				require_once 'components/Side_Bar.html';
			?>
			<div class="col-sm-9 col-md-10 col-lg-10 main">
				<h3>Stats</h3>
				<div class="row">
					<table id="example2" class="table table-striped table-bordered">
						<thead>
							<tr>
							<th>Kindergarten</th>
							<th>Grade 1</th>
							<th>Grade 2</th>
							<th>Grade 3</th>
							<th>Grade 4</th>
							<th>Grade 5</th>
							</tr>
						</thead>
						<tbody>
							<?php 
							include 'components/database.php';
							$pdo = Database::connect();
							$sql = "select sum(Kindergarten=1) as Kindergarten_t,sum(Grade1) as Grade1_t,sum(Grade2) as Grade2_t,sum(Grade3) as Grade3_t,sum(Grade4) as Grade4_t,sum(Grade5) as Grade5_t from stats";
							foreach ($pdo->query($sql) as $row) {
								echo '<tr>';
								echo '<td>'. $row['Kindergarten_t'] . '</td>';
								echo '<td>'. $row['Grade1_t'] . '</td>';
								echo '<td>'. $row['Grade2_t'] . '</td>';
								echo '<td>'. $row['Grade3_t'] . '</td>';
								echo '<td>'. $row['Grade4_t'] . '</td>';
								echo '<td>'. $row['Grade5_t'] . '</td>';
								echo '</tr>';
							}
							Database::disconnect();
							?>
						</tbody>
					</table>
				
				
					<table id="example" class="table table-striped table-bordered">
						<thead>
							<tr>
							<th>ID</th>
							<th>Name</th>
							<th>Phone</th>
							<th>Email</th>
							<th>Kindergarten</th>
							<th>Grade 1</th>
							<th>Grade 2</th>
							<th>Grade 3</th>
							<th>Grade 4</th>
							<th>Grade 5</th>
							</tr>
						</thead>
						<tbody>
							<?php 

							$pdo = Database::connect();
							$sql = "select ID,Name,Phone,Email,Kindergarten,Grade1,Grade2,Grade3,Grade4,Grade5 from stats";
	
							foreach ($pdo->query($sql) as $row) {
								echo '<tr>';
								echo '<td>'. $row['ID'] . '</td>';
								echo '<td>'. $row['Name'] . '</td>';
								echo '<td>'. $row['Phone'] . '</td>';
								echo '<td>'. $row['Email'] . '</td>';
								if ($row["Kindergarten"] == 1) {
									echo '<td style=background-color:#006633><b>'. $row['Kindergarten'] . '</b></td>';
								} else {
									echo '<td>'. $row['Kindergarten'] . '</td>';
								}
								if ($row["Grade1"] == 1) {
									echo '<td style=background-color:#006633><b>'. $row['Grade1'] . '</b></td>';
								} else {
									echo '<td>'. $row['Grade1'] . '</td>';
								}
								if ($row["Grade2"] == 1) {
									echo '<td style=background-color:#006633><b>'. $row['Grade2'] . '</b></td>';
								} else {
									echo '<td>'. $row['Grade2'] . '</td>';
								}
								if ($row["Grade3"] == 1) {
									echo '<td style=background-color:#006633><b>'. $row['Grade3'] . '</b></td>';
								} else {
									echo '<td>'. $row['Grade3'] . '</td>';
								}
								if ($row["Grade4"] == 1) {
									echo '<td style=background-color:#006633><b>'. $row['Grade4'] . '</b></td>';
								} else {
									echo '<td>'. $row['Grade4'] . '</td>';
								}
								if ($row["Grade5"] == 1) {
									echo '<td style=background-color:#006633><b>'. $row['Grade5'] . '</b></td>';
								} else {
									echo '<td>'. $row['Grade5'] . '</td>';
								}

								echo '</tr>';
							}
							Database::disconnect();
							?>
						</tbody>
					</table>
		   		</div>
			</div>
		</div>
	</div> <!-- /container -->
</body>
<?php
	require_once 'components/footer.php';
?>
</html>