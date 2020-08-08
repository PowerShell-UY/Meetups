<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meetup DEMO</title>
</head>
<style type="text/css">

body {
	font-family: Segoe UI Light,SegoeUILightWF,Arial,Sans-Serif;
}
table {
	color: black;
	margin: 10px;
	box-shadow: 1px 1px 6px #000;
	-moz-box-shadow: 1px 1px 6px #000;
	-webkit-box-shadow: 1px 1px 6px #000;
	border-collapse: separate;
}

table td {
	font-size: 14px;
}

table th {
	background-color:#647687;
	color:#ffffff;
	font-size: 14px;
	font-weight: bold;
}

.list table {
	margin-left:auto; 
	margin-right:auto;
}

.list td, .list th {
	padding:3px 7px 2px 7px;
}

</style>
<body>

<?PHP
if(!isset($_POST["submit"]))
{
    ?>
    <form name="testForm" id="testForm" action="index.php" method="post" />
        <input type="submit" name="submit" id="submit" value="Crear archivo" />
    </form>
    <?php    
}
// Else if submit was pressed, check if all of the required variables have a value:
elseif(isset($_POST["submit"]))
{
    $query = shell_exec('pwsh -file "/var/www/html/Demo3.ps1');
    echo $query;
}
// Else the user hit submit without all required fields being filled out:
else
{
    echo "Falló :(";
}

?>

</body>
</html>