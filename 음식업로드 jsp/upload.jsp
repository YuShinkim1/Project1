<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<% request.setCharacterEncoding("utf-8"); %>
<script>
    function closePopup() {
        window.opener.location.reload(); // 부모 창 새로고침
        window.close(); // 팝업 창 닫기
    }
</script>
</head>
<body>
<%
    // 데이터베이스 연결 정보
    String url = "jdbc:oracle:thin:@localhost:1521:XE"; // 데이터베이스 URL
    String username = "admin1"; // 데이터베이스 사용자명
    String password = "1234"; // 데이터베이스 비밀번호

    // 데이터베이스 연결
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, username, password);
        
        // INSERT INTO 문 실행
        String sql = "INSERT INTO cafe_food (food_name, food_price, food_category,cafe_no,food_img,food_no) VALUES (?, ?, ?,1,?,food_no.NEXTVAL)";
        pstmt = conn.prepareStatement(sql);
        
        // 사용자가 입력한 값 가져오기
        String foodName = request.getParameter("food_name");
        int foodPrice = Integer.parseInt(request.getParameter("food_price"));
        int foodCategory = Integer.parseInt(request.getParameter("food_category"));
        String food_img = request.getParameter("food_img");
        // INSERT할 값 설정
        pstmt.setString(1, foodName);
        pstmt.setInt(2, foodPrice); // 가격을 숫자형으로 설정
        pstmt.setInt(3, foodCategory); // 카테고리를 숫자형으로 설정
        pstmt.setString(4, food_img);
        // INSERT 실행
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            out.println("<script>alert('음식이 업로드되었습니다.'); closePopup();</script>");
        } else {
            out.println("<script>alert('음식이 업로드 되지 않았습니다.');</script>");
        }
    } catch (SQLException e) {
        out.println("데이터베이스 오류: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        out.println("드라이버 로드 오류: " + e.getMessage());
    } finally {
        // 리소스 해제
        if (pstmt != null) {
            try { pstmt.close(); } catch (SQLException e) { }
        }
        if (conn != null) {
            try { conn.close(); } catch (SQLException e) { }
        }
    }
%>
</body>
</html>
