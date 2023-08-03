<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%
    // JDBC 연결 정보
    String uid = "admin1";
    String pwd = "1234";
    String url = "jdbc:oracle:thin:@localhost:1521:XE";

    // AJAX 요청에서 전달된 필터 정보 가져오기
    String filter = request.getParameter("filter");

    // 데이터베이스 연결
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, uid, pwd);
        stmt = conn.createStatement();

        // 필터 정보에 따른 SQL 쿼리 작성
        String sql = "SELECT l.title, l.ori_prc, g.genre_no, l.thumnail_img " +
                     "FROM game_list l, game_genre g " +
                     "WHERE l.g_no = g.g_no ";

        if (filter != null && !filter.isEmpty()) {
            if (filter.equals("1인칭")) {
                sql += "AND g.genre_no = 0";
            } else if (filter.equals("내레이션")) {
                sql += "AND g.genre_no = 1";
            } else if (filter.equals("던전크롤러")) {
                sql += "AND g.genre_no = 2";
            } else if (filter.equals("도시건설")) {
                sql += "AND g.genre_no = 3";
            } else if (filter.equals("레이싱")) {
                sql += "AND g.genre_no = 4";
            } else if (filter.equals("레트로")) {
                sql += "AND g.genre_no = 5";
            }
            // 장르 정보 추가
            else if (filter.equals("로그라이트")) {
                sql += "AND g.genre_no = 6";
            }
            else if (filter.equals("생존")) {
                sql += "AND g.genre_no = 7";
            }
            else if (filter.equals("슈팅")) {
                sql += "AND g.genre_no = 8";
            }
            else if (filter.equals("스포츠")) {
                sql += "AND g.genre_no = 9";
            }
            else if (filter.equals("시뮬레이션")) {
                sql += "AND g.genre_no = 10";
            }
            else if (filter.equals("액션")) {
                sql += "AND g.genre_no = 11";
            }
            else if (filter.equals("액션_어드벤처")) {
                sql += "AND g.genre_no = 12";
            }
            else if (filter.equals("어드벤처")) {
                sql += "AND g.genre_no = 13";
            }
            else if (filter.equals("오픈_월드")) {
                sql += "AND g.genre_no = 14";
            }
            else if (filter.equals("우주")) {
                sql += "AND g.genre_no = 15";
            }
            else if (filter.equals("음악")) {
                sql += "AND g.genre_no = 16";
            }
            else if (filter.equals("인디")) {
                sql += "AND g.genre_no = 17";
            }
            else if (filter.equals("잠입")) {
                sql += "AND g.genre_no = 18";
            }
            else if (filter.equals("전략")) {
                sql += "AND g.genre_no = 19";
            }
            else if (filter.equals("전투")) {
                sql += "AND g.genre_no = 20";
            }
            else if (filter.equals("카드_게임")) {
                sql += "AND g.genre_no = 21";
            }
            else if (filter.equals("캐주얼")) {
                sql += "AND g.genre_no = 22";
            }
            else if (filter.equals("코미디")) {
                sql += "AND g.genre_no = 23";
            }
            else if (filter.equals("퀴즈")) {
                sql += "AND g.genre_no = 24";
            }
            else if (filter.equals("타워_디펜스")) {
                sql += "AND g.genre_no = 25";
            }
            else if (filter.equals("탐험")) {
                sql += "AND g.genre_no = 26";
            }
            else if (filter.equals("턴_기반_전략")) {
                sql += "AND g.genre_no = 27";
            }
            else if (filter.equals("턴제")) {
                sql += "AND g.genre_no = 28";
            }
            else if (filter.equals("파티")) {
                sql += "AND g.genre_no = 29";
            }
            else if (filter.equals("판타지")) {
                sql += "AND g.genre_no = 30";
            }
            else if (filter.equals("퍼즐")) {
                sql += "AND g.genre_no = 31";
            }
            else if (filter.equals("플랫포머")) {
                sql += "AND g.genre_no = 32";
            }
            else if (filter.equals("호러")) {
                sql += "AND g.genre_no = 33";
            }
            else if (filter.equals("MOBA")) {
                sql += "AND g.genre_no = 34";
            }
            else if (filter.equals("RPG")) {
                sql += "AND g.genre_no = 35";
            }
            else if (filter.equals("RTS")) {
                sql += "AND g.genre_no = 36";
            }
        }

        // 쿼리 실행 및 결과 반환
        rs = stmt.executeQuery(sql);

        // 결과 처리
        int gameCount = 5; // 게임 개수 카운트 변수
        while (rs.next()) {
            String title = rs.getString("title");
            int ori_prc = rs.getInt("ori_prc");
            String thumnail_img = rs.getString("thumnail_img");

            if (gameCount % 5 == 0) {
                // 5개의 게임마다 새로운 행 추가
                if (gameCount > 0) {
        %>
        </div>
    <div class="game-row">
        <% } %>
        <div class="game-item">
            <img src="<%= thumnail_img %>" alt="<%= title %>" width="220" height="290" style="border-radius:4px"/>
            <div class="game-info"style="
    width: 222px;
    border-radius:4px;
"	>
                <%= title %>
                <br><br>
                <%if(ori_prc==0){ %>
                	무료
                <% }else{%>
                ₩<%= ori_prc %>
                <%} %>
                <br><br>
            </div>
        </div>
        <% 
            } else {
        %>
        <div class="game-item">
            <img src="<%= thumnail_img %>" alt="<%= title %>" width="220" height="290" style="border-radius:4px"/>
            <div class="game-info"style="
    width: 222px;
">
                <%= title %>
                <br><br>
                <%if(ori_prc==0){ %>
                	무료
                <% }else{%>
                ₩<%= ori_prc %>
                <%} %>
                <br><br>
            </div>
        </div>
        <% } %>
        <% 
            gameCount++;
        } 

        // 마지막 행 닫기
        if (gameCount > 0) {
        %>
    </div>
    <% } %>

    <% 
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
