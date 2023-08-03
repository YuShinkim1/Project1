<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>
<title>PC방 음식 업로드</title>
<%
	request.setCharacterEncoding("utf-8");
%>
<style>
body {
	width:500px;
	height:500px;
	background:#202020;
}

#submitBtn {
	width: 300px;
    height: 50px;
    background: yellow;
    border: 1px solid purple;
    margin-left: 0px;
    border-radius: 10px;
}
.view{
	height:200px;
	width:300px;
	border:1px solid white;
}
.upload{
	text-align:center;
}
#menutextbox{
    margin-left: 100px;
}
.view{
	margin-left: 100px;
	color:white;
}
#imageInput{
	margin-left: 100px;
	color:white;
}
#foodCategory{
 width: 180px;
    height: 30px;
    border-radius: 10px;
}
.upload{
	width:537px;
	height:50px;
    background: gold;
    margin-left: -8px;
    line-height: 50px;
}
label{
	color:white;
	font-size:25px;
}
#foodName{
	
    width: 180px;
    height: 30px;
    border-radius: 10px;

}
#foodPrice{
	
    width: 180px;
    height: 30px;
    border-radius: 10px;

}
</style>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
  <script>
    function previewImage(input) {
      if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function(e) {
          $('#preview').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
      }
    }
  </script>
</head>
<body>

	<div class="upload"><h2>상품 등록</h2></div><br><br>
	 <div class="view">
  <img id="preview" src="#" alt="미리보기" width="300" height="200">
  </div>
  <br>
  <input type="file" id="imageInput" onchange="previewImage(this);" accept="image/*">
  <br><br>
		<form method="POST" action="upload.jsp" id="menutextbox">
			<label for="foodName">음식 이름:</label> 
			<input type="text" name="food_name" id="foodName" autocomplete="off"/>
			<br/> <br/>
			<label for="foodPrice" id="foodPrice2">음식 가격:</label> 
			<input type="text" name="food_price" id="foodPrice" autocomplete="off"/>
			<br/>
			<br> 
			<span style="color:white;font-size:25px;">
			상품 분류: 
			</span>
			<select name="food_category" id="foodCategory">
				<option value="0">분식</option>
				<option value="1">탄산음료</option>
				<option value="2">라면</option>
				<option value="3">카페음료</option>
				<option value="4">한식</option>
			</select>
			
			<br> <br> 
			
			<br/>
			<br>
			<button id="submitBtn"><img src="image/upload.png" style="width:20px;height:20px;margin-bottom: -4px;">등록</button>
	</form>
	<br><br>
</body>
</html>
