<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>

<!DOCTYPE html>
<html>
<head>
<title>PC방 주문확인</title>
   <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f2f2f2;
      padding: 20px;
    }
    
    h2 {
      text-align: center;
      color: #333333;
      margin-bottom: 20px;
    }
    
    .container {
      display: flex;
    flex-wrap: wrap;
    justify-content: flex-start;
    margin-left: 150px;
    }
    
    .row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    
    .box {
      width: 500px;
      background-color: white;
      border: 1px solid #333333;
      margin-right: 20px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      border-radius:5px;
    }
    
    .box-header {
        border-radius: 3px;
        
    padding: 10px;
    background-color: darkmagenta;
    font-weight: bold;
    text-align: center;
    color: white;
    width: 60px;
    line-height: 180px;
    font-size: 40px;
    font-weight: 500;
    }
    
    .box-body {
      padding: 10px;
      min-height: 60px;
      font-size: 20px;
      font-weight: bold;
      color:black;
    }
    
    .title {
      font-size: 15px;
      font-weight: bold;
      margin-top: 10px;
    }
    
    .comment {
      font-size: 15px;
      color: gray;
    }
    
    .box-footer {
    padding: 10px;
    background-color: white;
    border-top: 1px solid #333333;
    text-align: right;
    width: 400px;
    border-radius: 5px;
    }
    
    .total-price {
      font-weight: bold;
      margin-right: 5px;
      color:black;
    }
    .s{
    	display:flex;
    }
    button{
      border-radius: 15px;
      width: 100px;
      height: 30px;
      background: white;
          font-weight: bold;
    font-size: 17px;
    }
    
    /* 버튼 색상 변경을 위한 클래스 추가 */
    .button-magenta {
      background-color: #D258B0;
    }
    
    .button-skyblue {
      background-color: #5889d3;
    }
    *, *::before, *::after {
	  box-sizing: revert !important;
	}
  </style>
</head>
<body>

<%
Connection conn = null;
Statement stmt = null;
ResultSet rs = null;
String uid = "admin1";
String pwd = "1234";
String url = "jdbc:oracle:thin:@localhost:1521:XE";
String sql = "SELECT o.food_name,o.food_price,o.food_count,o.food_comment,o.seat_no,o.pay_tool\r\n" + 
    "FROM cafe_food f, cafe_food_order_list o\r\n" + 
    "WHERE f.food_name = o.food_name \r\n" + 
    "ORDER BY o.seat_no ASC";

try {
    // 데이터베이스를 접속하기 위한 드라이버 SW 로드
    Class.forName("oracle.jdbc.driver.OracleDriver");
    // 데이터베이스에 연결하는 작업 수행
    conn = DriverManager.getConnection(url, uid, pwd);
    // 쿼리를 생성하는 객체 생성
    stmt = conn.createStatement();
    // 쿼리 생성
    rs = stmt.executeQuery(sql);

    // HashMap 생성
    HashMap<Integer, ArrayList<HashMap<String, Object>>> orderMap = new HashMap<>();

    // ResultSet에서 데이터를 읽어와 HashMap에 저장
    while (rs.next()) {
        int seatNo = rs.getInt("seat_no");
        HashMap<String, Object> order = new HashMap<>();
        order.put("seatNo", seatNo);
        order.put("payTool", rs.getInt("pay_tool"));
        String comment = rs.getString("food_comment");
        order.put("orderComment", comment != null ? comment : "[요청사항 없음]");
        order.put("foodName", rs.getString("food_name"));
        order.put("count", rs.getInt("food_count"));
        order.put("foodPrice", rs.getInt("food_price"));

        if (orderMap.containsKey(seatNo)) {
            ArrayList<HashMap<String, Object>> orderList = orderMap.get(seatNo);
            orderList.add(order);
        } else {
            ArrayList<HashMap<String, Object>> orderList = new ArrayList<>();
            orderList.add(order);
            orderMap.put(seatNo, orderList);
        }
    }
%>
<jsp:include page="NavBar2.jsp"/>

<h1 style="text-align: center;">주문 현황</h1>
<br><br><br>
<div class="container">
    <%
    int boxCount = 0; // 박스 개수를 세는 변수 추가
    for (int seatNo : orderMap.keySet()) {
        ArrayList<HashMap<String, Object>> orderList = orderMap.get(seatNo);
        if (boxCount % 3 == 0) {
    %>
    <div class="row">
    <% } %>
        <div class="box">
        <div class="s">
            <div class="box-header" ><%= seatNo %>
            </div>
            <div class="main">
                <div class="box-body">
                    <% for (HashMap<String, Object> order : orderList) { %>
                    [<%= order.get("foodName") %> X <%= order.get("count") %>]
                    <% } %>
                   
                </div>
                <div class="box-body">
    <%= orderList.get(0).get("orderComment") %> &emsp;&emsp;&emsp;&emsp;&emsp;
    &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;<u style="font-size: 14px;color: red;">판매취소</u>
</div>
                <div class="box-footer">
                    <% int totalPrice = 0;
                       int payTool = -1; // 초기값 설정
                       for (HashMap<String, Object> order : orderList) {
                           int foodPrice = Integer.parseInt(order.get("foodPrice").toString());
                           int count = Integer.parseInt(order.get("count").toString());
                           totalPrice += foodPrice * count;

                           // payTool 값을 읽어와서 저장
                           payTool = (int) order.get("payTool");
                       }
                    %>
                    <div class="total-price"><%= totalPrice %>
                        <% if (payTool == 0) { %>
                            [현금]
                        <% } else if (payTool == 1) { %>
                            [카드]
                        <% } else if (payTool == 2) { %>
                            [쿠폰]
                        <% } %>
                     &emsp;&emsp;&emsp;&emsp;&emsp;<button class="btn-preparing">준비중</button>&emsp;<button class="btn-delivered" data-seatNo="<%= seatNo %>" onclick="deleteOrder(<%= seatNo %>)">전달완료</button>

                    </div>
                    
                </div>
            </div>
        </div>
        </div>
    <% if (boxCount % 3 == 2) { %>
    </div>
    <% }
       boxCount++;
    } %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
} finally {
    try {
        if (rs != null) {
            rs.close();
        }
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
<!-- JavaScript 코드 -->
<script>
  // 준비중 버튼 누를 시 색상 변경
  var preparingButtons = document.getElementsByClassName("btn-preparing");
  for (var i = 0; i < preparingButtons.length; i++) {
    preparingButtons[i].addEventListener("click", function () {
      if (this.classList.contains("button-magenta")) {
        this.classList.remove("button-magenta");
        this.style.color = "black";
      } else {
        this.classList.add("button-magenta");
        this.style.color = "white";
      }
    });
  }

  var selectedButton = null; // 사용자가 선택한 전달완료 버튼을 저장할 변수

  function deleteOrder(seatNo) {
    if (confirm("정말로 주문을 삭제하시겠습니까?")) {
      // 3초 후에 주문 삭제 처리
      var result = true; // Replace this with your actual logic to delete the order

      if (result) {
    	  var deliveredButton = document.querySelector(".btn-delivered[data-seatNo='" + seatNo + "']");
          if (deliveredButton) {
            // Update the button styles
            deliveredButton.classList.add("button-skyblue");
            deliveredButton.style.color = "white";
          }
        setTimeout(function () {
          window.location.href = "delete_order.jsp?seatNo=" + seatNo;
        }, 3000);
      }
    } else {
      alert("취소되었습니다!");
      // 여기에 취소를 눌렀을 때 수행할 명령어를 작성할 수 있습니다.
    }
  }
</script>



</body>
</html>
