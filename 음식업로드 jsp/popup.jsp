<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <script>
        function popup(){
            var url = "cafeupload.jsp";
            var name = "음식 업로드";
            var option = "width=500, height=500, top=100, location=no, resizable=yes";
            var popupWindow = window.open(url, name, option);
            popupWindow.document.body.style.backgroundColor = "#ff0000"; /* 배경색을 원하는 색상으로 변경하세요 */
        }
    </script>
    <style>
        .popup-link {
            color: #0000ff; /* 링크 텍스트의 색상을 원하는 색상으로 변경하세요 */
        }
    </style>
</head>
<body>
 <a href="#" onclick="popup()" class="popup-link">상품등록</a>
</body>
</html>
