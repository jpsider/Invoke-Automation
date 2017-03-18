<!DOCTYPE html>
<html lang="en">
<?php
	require_once 'components/header.php';
?>

<body>
    <div class="container" style="margin-left:10px">
    	<div class="row">
			<?php
				require_once 'components/Side_Bar.html';
			?>
			<div class="col-sm-9 col-md-10 col-lg-10 main">
				<h3>Select all Grades that Apply.</h3>
				<div class="row">
					<table id="example" class="table table-striped table-bordered">
						<thead>
							<tr>
							<th>Full Name</th>
							<th>Phone</th>
							<th>Email</th>
							</tr>
						</thead>
						<tbody>
							<?php 

								echo '<tr><form action="createRecord.php" method="get">';
								echo '<td><input type="text" name="Full_Name" value=""></td>';
								echo '<td><input type="text" name="Phone" value=""></td>';
								echo '<td><input type="text" name="Email" value=""></td>';
								echo '</tr><tr><th>Kindergarten</th><th>Grade 1</th><th>Grade 2</th></tr>';
								echo '<td><input type="checkbox" name="Kindergarten" value="1"></td>';
								echo '<td><input type="checkbox" name="Grade1" value="1"></td>';
								echo '<td><input type="checkbox" name="Grade2" value="1"></td></tr>';
								echo '<tr><th>Grade 3</th><th>Grade 4</th><th>Grade 5</th></tr><tr>';
								echo '<td><input type="checkbox" name="Grade3" value="1"></td>';
								echo '<td><input type="checkbox" name="Grade4" value="1"></td>';
								echo '<td><input type="checkbox" name="Grade5" value="1"></td></tr>';
								echo '<tr><th></th><th>Submit Entry</th><th></th></tr>';
								echo '<tr><td></td><td><input type="submit" class="btn btn-info" value="Submit Entry"></form></td><td>';
								echo '</td>';
								echo '</tr>';
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