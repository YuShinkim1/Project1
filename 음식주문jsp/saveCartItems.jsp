<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="org.json.JSONArray"%>
<%@ page import="org.json.JSONObject"%>

<head>
    <meta charset="UTF-8">
    <%request.setCharacterEncoding("utf-8");%>
</head>

<%
    // 장바구니 데이터를 전송받음
    request.setCharacterEncoding("utf-8");
    String cartItemsJson = request.getParameter("cartItems");
    List<Map<String, Object>> cartItems = new ArrayList<>();

    try {
        JSONArray jsonArray = new JSONArray(cartItemsJson);

        // JSON 배열을 List<Map> 형태로 변환
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = jsonArray.getJSONObject(i);
            Map<String, Object> item = new HashMap<>();
            item.put("foodNo", jsonObject.getString("foodNo"));
            item.put("foodName", jsonObject.getString("foodName"));
            item.put("foodPrice", jsonObject.getInt("foodPrice"));
            item.put("quantity", jsonObject.getInt("quantity")); // 장바구니에 담긴 수량 추가
            cartItems.add(item);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    String uid = "admin1";
    String pwd = "1234";
    String url = "jdbc:oracle:thin:@localhost:1521:XE?useUnicode=true&characterEncoding=UTF-8";

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, uid, pwd);

        // 장바구니 데이터를 데이터베이스에 저장
        for (Map<String, Object> item : cartItems) {
            String foodName = (String) item.get("foodName");
            int foodPrice = (int) item.get("foodPrice");
            int quantity = (int) item.get("quantity");
            String sql = "INSERT INTO cafe_food_Order_List (food_price, food_name, food_count, pay_tool, seat_no, food_comment) VALUES (?, ?, ?, 1, 89, '없음')";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, foodPrice);
            pstmt.setString(2, foodName);
            pstmt.setInt(3, quantity);
            pstmt.executeUpdate();
        }

        // 데이터베이스에 저장 완료 메시지 전송
        response.getWriter().println("장바구니 데이터가 성공적으로 저장되었습니다.");
    } catch (Exception e) {
        e.printStackTrace();
        // 에러 메시지 전송
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "장바구니 데이터를 저장하는 중에 오류가 발생했습니다.");
    } finally {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>


