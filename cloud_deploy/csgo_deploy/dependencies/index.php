<!DOCTYPE html>
<html>
<head>
  <title>Map Upload</title>
  <meta charset="UTF-8">
 <style>
div {
  height: 10em;
  display: flex;
  align-items: center;
  justify-content: center;  
 }
  body {
    background-color: #404041;
}
</style>
</head>
<body>
<div style="color:Tomato;">
  <form enctype="multipart/form-data" action="" method="POST">
    <p>Map Upload</p>
    <input type="file" name="uploaded_file"></input><br />
    <input type="submit" value="Upload"></input>
  </form>
  </div>
</body>
</html>
<?PHP
  if(!empty($_FILES['uploaded_file']))
  {
    $path = "{MAP_FOLDER_PATH}";
    $path = $path . basename( $_FILES['uploaded_file']['name']);

    if(move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $path)) {
      echo "The file ".  basename( $_FILES['uploaded_file']['name']). 
      " has been uploaded";
    } else{
        echo "There was an error uploading the file, please try again!";
    }
  }
$row = exec('ls {MAP_FOLDER_PATH} | grep .bsp',$output,$error);
while(list(,$row) = each($output)){
echo $row, "<BR>\n";
}
if($error){
echo "Error : $error<BR>\n";
exit;
}
?>
