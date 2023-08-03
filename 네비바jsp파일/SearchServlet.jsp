<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%
String keyword = request.getParameter("keyword");

// Oracle 연결 정보 설정
String url = "jdbc:oracle:thin:@localhost:1521:xe"; // Oracle 데이터베이스 URL
String username = "admin1"; // Oracle 사용자명
String password = "1234"; // Oracle 비밀번호

// JDBC 드라이버 로드
try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
} catch (ClassNotFoundException e) {
    e.printStackTrace();
}

try (Connection conn = DriverManager.getConnection(url, username, password)) {
    String sql = "SELECT title, thumnail_img FROM game_list WHERE title LIKE ?";
    PreparedStatement stmt = conn.prepareStatement(sql);
    stmt.setString(1, "%" + keyword + "%");
    ResultSet rs = stmt.executeQuery();

    // 검색 결과를 JSON 배열로 변환
    JSONArray results = new JSONArray();
    while (rs.next()) {
        String title = rs.getString("title");
        String thumbnailImg = rs.getString("thumnail_img");
        
        // 검색 결과 객체 생성
        JSONObject result = new JSONObject();
        result.put("title", title);
        result.put("thumbnailImg", thumbnailImg);
        
        results.put(result);
    }

    // JSON 응답 반환
    response.setContentType("application/json; charset=UTF-8");
    response.getWriter().print(results);
} catch (SQLException e) {
    e.printStackTrace();
}
%>
	