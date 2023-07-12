<html>
<head>
	<meta charset="UTF-8"/>
	<meta name="robots" content="noindex,nofollow">
	<meta content="" name="description"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Run igram.py</title>
<?PHP
	echo shell_exec("python3 igram.py $_POST['username'] $_POST['passwd'] $_POST['postID']");
?>
</head>
<body>
<div class="container">
<div class="columns">
<div class="column"></div>
<div class="column is-one-third">
<div class="box">

</div>
</div>
<div class="column"></div>
</div>
</div>
</body>
</html>
