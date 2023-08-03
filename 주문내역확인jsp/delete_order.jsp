<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.HashMap"%>

<%
Connection conn = null;
Statement stmt = null;
String uid = "admin1";
String pwd = "1234";
String url = "jdbc:oracle:thin:@localhost:1521:XE";

try {
    int seatNo = Integer.parseInt(request.getParameter("seatNo"));

    // 데이터베이스를 접속하기 위한 드라이버 SW 로드
    Class.forName("oracle.jdbc.driver.OracleDriver");
    // 데이터베이스에 연결하는 작업 수행
    conn = DriverManager.getConnection(url, uid, pwd);
    // 쿼리를 생성하는 객체 생성
    stmt = conn.createStatement();
    // 쿼리 생성
    String sql = "DELETE FROM cafe_food_order_list WHERE seat_no = " + seatNo;
    stmt.executeUpdate(sql);

    response.sendRedirect("pccafeowner.jsp"); // 주문 현황 페이지로 리다이렉트

} catch (Exception e) {
    e.printStackTrace();
} finally {
    try {
        if (stmt != null) {
            stmt.close();
        }
        if (conn != null) {
            conn.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
}
%>
