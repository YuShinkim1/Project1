<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%!// 변수 선언
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String uid = "admin1";
	String pwd = "1234";
	String url = "jdbc:oracle:thin:@localhost:1521:XE";
	String sql = "SELECT title,thumnail_img,ori_prc\r\n" + 
			" FROM game_list"+
			" WHERE ROWNUM <= 40";%>
<%
    // request.getParameter > 해당 파라미터의 값을 리턴
    // Integer.parseInt("1") > 1을 리턴
    int pageNum;
    try {
        pageNum = Integer.parseInt(request.getParameter("page"));
    } catch(NumberFormatException e) {
        // pageNum을 1로 만들어.
        pageNum = 1;
    }

%>

<%!
    public Connection getConnection() throws Exception {
        String driver = "oracle.jdbc.driver.OracleDriver";
        String url = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbId = "admin1";
        String dbPw = "1234";
        String sql = "SELECT b2.*\r\n" +
                "FROM(SELECT rownum rnum,b1.*\r\n" +
                "FROM(SELECT*FROM game_list ORDER BY g_no desc)b1)b2\r\n" +
                "WHERE rnum>=1 AND rnum<=20";

        Class.forName(driver);
        Connection conn = DriverManager.getConnection(url, dbId, dbPw);
        return conn;
    }

%>
<!DOCTYPE html>
<html>
<head>
<title>찾아보기</title>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/find.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script>
    function getGames(filter, button) {
        // AJAX를 사용하여 서버에서 게임 목록을 가져옴
        var xhttp = new XMLHttpRequest();
        
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                document.getElementById("gameList").innerHTML = this.responseText;

                // 버튼 클릭 시 버튼의 스타일을 변경
                var buttons = document.getElementsByClassName("button eventButton");
                for (var i = 0; i < buttons.length; i++) {
                    buttons[i].style.borderColor = "";
                }
                button.style.borderColor = "white"; // 누른 버튼의 테두리 색을 빨간색으로 변경
            }
        };
        xhttp.open("GET", "getGames.jsp?filter=" + filter, true);
        xhttp.send();
    }
</script>
<script>
	function showHiddenEvent() {
		var button = document.getElementById("eventButton");
		var hiddenEvent = document.getElementById("hiddenEvent");
		var img = document.getElementById("eventImage");
		if (hiddenEvent.classList.contains("show")) {
			hiddenEvent.classList.remove("show");
			img.src = "image/32196.png";
		} else {
			hiddenEvent.classList.add("show");
			img.src = "image/32197.png";
		}
	}

	function showHiddenPrice() {
		var hiddenPrice = document.getElementById("hiddenPrice");
		hiddenPrice.classList.toggle("show");
		var img = document.getElementById("priceImage");
		if (hiddenPrice.classList.contains("show")) {
			img.src = "image/32197.png";
		} else {
			img.src = "image/32196.png";
		}
	}

	function showHiddenGenre() {
		var hiddenGenre = document.getElementById("hiddenGenre");
		hiddenGenre.classList.toggle("show");
		var img = document.getElementById("genreImage");
		if (hiddenGenre.classList.contains("show")) {
			img.src = "image/32197.png";
		} else {
			img.src = "image/32196.png";
		}
	}

	function showHiddenPlatform() {
		var hiddenPlatform = document.getElementById("hiddenPlatform");
		hiddenPlatform.classList.toggle("show");
		var img = document.getElementById("platformImage");
		if (hiddenPlatform.classList.contains("show")) {
			img.src = "image/32197.png";
		} else {
			img.src = "image/32196.png";
		}
	}
</script>
<style>
.bottom-footer{
position: relative;
    left: -150px;
    top: 200px;
}
#dod{
    position: relative;
    top: -239px;
    left: -1194px;
    width: 20px;
    height: 20px;
}
.ka{
position: relative;
}
.left-nav{
align-items: center;
}
.nav-item-block {
    background-color: rgb(204, 204, 204);
    height: 50%;
    margin: 0px 16px;
    width: 1px;
    height:26px;
}
#kabtn {
    color: gray;
    position: relative;
    left: 50px;
    bottom: 0px;
}
</style>
</head>
<body>
<jsp:include page="NavBar2.jsp"/>
<jsp:include page="NewFile3.jsp"/>	
<body bgcolor='black'style="
    background: black;
">

	<div id="suggestionsContainer"
		style="position: fixed;top: 0;top: 75px;left: 0px;width: 300px;right: 8px;/* border: 1px solid black; */background-color: black;"></div>


	<div class="nav-subtitle"
		style="color: white; font-size: 25px; margin-left: 150px;">
		<br>인기 장르
	</div>
	<br>
	<div
		style="background-color: rgb(32, 32, 32); width: 275px; height: 220px; display: inline-block; border: 1px solid black; margin-left: 150px;">
		<img
			src=https://cdn1.epicgames.com/spt-assets/bec551dc89634bf2a777f523cde3cead/influent-definitive-edition-3cwrm.png?h=480&quality=medium&resize=1&w=360
			style="position: relative; left: 20px; bottom: -20px;" alt="mac게임"
			width="110px" height="150px"> <img
			src=https://cdn1.epicgames.com/spt-assets/cb35ff2ed593499b8bf954f248c6fc07/poosh-xl-1ccca.png?h=480&quality=medium&resize=1&w=360
			style="position: relative; bottom: -20px; left: 20px;" alt="mac게임"
			width="110px" height="150px"> <img
			src=https://cdn1.epicgames.com/spt-assets/059288cd2aee49b8b7a5d4e21bf178c0/death-or-treat-1lnw7.jpg?h=480&quality=medium&resize=1&w=360
			style="position: relative; right: -79px; bottom: 134px;" alt="mac게임"
			width="110px" height="150px">
		<div class="pop"
			style="color: white; font-size: 25px; position: relative; bottom: 160px; left: 81px;">
			<br>Mac 게임
		</div>
		<br>
	</div>
	<div
		style="width: 275px; height: 220px; background-color: white; display: inline-block; border: 1px solid black; margin-left: 20px;">
		<div
			style="position: relative; right: 150px; background-color: rgb(32, 32, 32); width: 275px; height: 220px; display: inline-block; /* border:1px solid black; */ margin-left: 150px;">
			<img
				src=https://cdn1.epicgames.com/offer/879b0d8776ab46a59a129983ba78f0ce/PortraitProductImage-KOR_1200x1600-0379125a5dee5bbda79bf68aaac62146?h=480&quality=medium&resize=1&w=360
				style="position: relative; left: 20px; bottom: -20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/ark/offer/EGS_ARKSurvivalEvolved_StudioWildcard_S2-1200x1600-5b58fdefea9f885c7426e894a1034921.jpg?h=480&quality=medium&resize=1&w=360
				style="position: relative; bottom: -20px; left: 20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/offer/428115def4ca4deea9d69c99c5a5a99e/FR_Bungie_Destiny2_S2_1200x1600_1200x1600-c04030c570b63cdced320be0f88a9f89?h=480&quality=medium&resize=1&w=360
				style="position: relative; right: -79px; bottom: 134px;" alt="mac게임"
				width="110px" height="150px">
			<div class="pop"
				style="color: white; font-size: 25px; position: relative; bottom: 160px; left: 81px;">
				<br>MMO 게임
			</div>
			<br>
		</div>
	</div>
	<div
		style="width: 275px; height: 220px; background-color: white; display: inline-block; border: 1px solid black; margin-left: 20px;">
		<div
			style="position: relative; right: 150px; background-color: rgb(32, 32, 32); width: 275px; height: 220px; display: inline-block; /* border:1px solid black; */ margin-left: 150px;">
			<img
				src=https://cdn1.epicgames.com/spt-assets/3c87c2d59aa74c46991f82dd3c8ac43e/fuga-melodies-of-steel-2-6u110.png?h=480&quality=medium&resize=1&w=360
				style="position: relative; left: 20px; bottom: -20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/spt-assets/6adefbc606a9437c95bdcbc81d7b8ef5/outcore--desktop-adventure-1szpl.jpg?h=480&quality=medium&resize=1&w=360
				style="position: relative; bottom: -20px; left: 20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/offer/3428aaab2c674c98b3acb789dcfaa548/EGS_FalloutNewVegas_ObsidianEntertainment_S2_1200x1600-866fe8b8f56e2e7bb862c49bf0627b9a?h=480&quality=medium&resize=1&w=360
				style="position: relative; right: -79px; bottom: 134px;" alt="mac게임"
				width="110px" height="150px">
			<div class="pop"
				style="color: white; font-size: 25px; position: relative; bottom: 160px; left: 105px;">
				<br>RPG
			</div>
			<br>
		</div>
	</div>
	<div
		style="width: 275px; height: 220px; background-color: white; display: inline-block; border: 1px solid black; margin-left: 20px;">
		<div
			style="position: relative; right: 150px; background-color: rgb(32, 32, 32); width: 275px; height: 220px; display: inline-block; /* border:1px solid black; */ margin-left: 150px;">
			<img
				src=https://cdn1.epicgames.com/offer/7ec453d446194b8f8afe82aaa9561211/XCOM2_Set_Up_Assets_1200x1600_1200x1600-4b0c6e42af847235877992095e154563_1200x1600-4b0c6e42af847235877992095e154563?h=480&quality=medium&resize=1&w=360
				style="position: relative; left: 20px; bottom: -20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/dda64c2956b54f1ba3cd97f6aaee775f/offer/EGS_TotalWarWARHAMMERIII_CreativeAssembly_S6-1200x1600-bf935f14317eaf51f4906079a2888ced.jpg?h=480&quality=medium&resize=1&w=360
				style="position: relative; bottom: -20px; left: 20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/spt-assets/4ed68d2dbe5b4bfea278f67d368e7791/roma-invicta-10z2z.png?h=480&quality=medium&resize=1&w=360
				style="position: relative; right: -79px; bottom: 134px;" alt="mac게임"
				width="110px" height="150px">
			<div class="pop"
				style="color: white; font-size: 25px; position: relative; bottom: 160px; left: 81px;">
				<br>RTS 게임
			</div>
			<br>
		</div>
	</div>
	<div
		style="width: 275px; height: 220px; background-color: white; display: inline-block; border: 1px solid black; margin-left: 20px;">
		<div
			style="position: relative; right: 150px; background-color: rgb(32, 32, 32); width: 275px; height: 220px; display: inline-block; /* border:1px solid black; */ margin-left: 150px;">
			<img
				src=https://cdn1.epicgames.com/offer/sweetpea/EGS_TroverSavestheUniverse_SquanchGames_S2_1200x1600-d743ab2d38e2b438fd17ee88eab7a55e?h=480&quality=medium&resize=1&w=360
				style="position: relative; left: 20px; bottom: -20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/offer/19078740fbcc4eada59a5a4ae7b3724c/GNOG_EGS_1200x1600_1200x1600-1a2e2880f6b51ca6f6f202829a4b99c2?h=480&quality=medium&resize=1&w=360
				style="position: relative; bottom: -20px; left: 20px;" alt="mac게임"
				width="110px" height="150px"> <img
				src=https://cdn1.epicgames.com/offer/76339caf9e8e4d24b62761c736e82b42/EGS_TetrisEffectConnected_MonstarsincResonairStageGames_S2_1200x1600-198972bf794d088c3cb15e71bac9f0e2?h=480&quality=medium&resize=1&w=360
				style="position: relative; right: -79px; bottom: 134px;" alt="mac게임"
				width="110px" height="150px">
			<div class="pop"
				style="color: white; font-size: 25px; position: relative; bottom: 160px; left: 90px;">
				<br>VR 게임
			</div>
			<br>
		</div>
	</div>
	<div class="subtitle" style="POSITION: relative; bottom: 100px;">

		<div class="nav-subtitle">
			<span style="margin-left: 150px; color: white">표시: 신작</span>
		</div>
		<div class="nav-right-items"></div>
	</div>

		
				<div class="greeting"
					style="position: relative; left: 350px; bottom: 350px;">
					<div class="subprice-item2"style="
    position: relative;
    left: 1050px;
    top: 252px;
">
						<span style="font-size: 13px; color: white">필터
							(1)&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
							초기화</span>
					</div>
					<div class="subprice-item4">
						<br>
						<span style="color: white"><div id="post_searchGlass"
								style="position: relative;top: 236px;right: 0px;width: 24px;height: 40px;bottom: -239px;left: 1046px;"></div>
							<input type="text"  id="searchInput name="Commu_Search"
							placeholder="키워드" spellcheck="false" autocomplete="off"
							class="search-input"
							style="background: rgb(32, 32, 32);position: relative;bottom: -196px;left: 1070px;width: 215px;height: 40px;z-index: 9000;color: white;">
							<img src="image/1111.png" alt="돋보기"
							style="position: relative;top: 200px;left: 833px;width: 20px;height: 20px;z-index: 9000;"></span>
					</div>
					<div class="my"style="
    position: absolute;
">
					<div class="subprice-item2"
						style="
	position: relative;
	top: -37px;
	/* border-top: 1px solid gray; */
	/* border-bottom: 1px solid gray; */
	/* bottom: 65px; */
	left: 1049px;
	top: 180px;
	z-index: 9000;
	">
						<br>


						<button id="eventButton" class="button eventButton"
							onclick="showHiddenEvent()"
							style="border-bottom: 1px solid gray;">
							이벤트<img id="eventImage" src="image/32196.png" alt="이벤트 보기 1"
								style="width: 15px; height: 15px; position: relative; left: 170px;">
						</button>
						<div id="hiddenEvent" class="hiddenContent"
							style="color: gray; border-bottom: 1px solid gray;">
							<br>에픽 메가 세일<br>
							<br>
						</div>

						<br>
						<br>
						<button class="button eventButton" onclick="showHiddenPrice()"
							style="border-bottom: 1px solid gray;">
							가격 <img id="priceImage" src="image/32196.png" alt="이벤트 보기 1"
								style="width: 15px; height: 15px; position: relative; left: 180px; top: 0px;">
						</button>
						<div id="hiddenPrice" class="hiddenContent"
							style="color: gray; border-bottom: 1px solid gray;">
							<br>무료<br>
							<br> ₩11,000 미만<br>
							<br> ₩22,000 미만<br>
							<br> ₩33,000 미만<br>
							<br> ₩15,000 이상<br>
							<br> 할인<br>
							<br>
						</div>

						<br>
						<br>
						<button class="button eventButton" onclick="showHiddenGenre()"
							style="border-bottom: 1px solid gray;">
							장르 <img id="genreImage" src="image/32196.png" alt="이벤트 보기 1"
								style="width: 15px; height: 15px; position: relative; left: 180px; top: 0px;">
						</button>
						<div id="hiddenGenre" class="hiddenContent"
							style="color: gray; border-bottom: 1px solid gray;">
        <button class="button eventButton" onclick="getGames('1인칭', this)">&nbsp;&nbsp;1인칭</button><br>
        <button class="button eventButton" onclick="getGames('내레이션', this)">&nbsp;&nbsp;내레이션</button><br>
        <button class="button eventButton"  onclick="getGames('도시건설', this)">&nbsp;&nbsp;도시건설</button><br>
        <button class="button eventButton"  onclick="getGames('레이싱', this)">&nbsp;&nbsp;레이싱</button><br>
        <button class="button eventButton"  onclick="getGames('레트로', this)">&nbsp;&nbsp;레트로</button><br>
        <button class="button eventButton"  onclick="getGames('로그라이트', this)">&nbsp;&nbsp;로그라이트</button><br>
        <button class="button eventButton"  onclick="getGames('생존', this)">&nbsp;&nbsp;생존</button><br>
        <button class="button eventButton"  onclick="getGames('슈팅', this)">&nbsp;&nbsp;슈팅</button><br>
        <button class="button eventButton"  onclick="getGames('스포츠', this)">&nbsp;&nbsp;스포츠</button><br>
        <button class="button eventButton"  onclick="getGames('시뮬레이션', this)">&nbsp;&nbsp;시뮬레이션</button><br>
        <button class="button eventButton"  onclick="getGames('액션', this)">&nbsp;&nbsp;액션</button><br>
        <button class="button eventButton"  onclick="getGames('액션_어드벤처', this)">&nbsp;&nbsp;액션 어드벤처</button><br>
        <button class="button eventButton"  onclick="getGames('어드벤처', this)">&nbsp;&nbsp;어드벤처</button><br>
        <button class="button eventButton"  onclick="getGames('오픈_월드', this)">&nbsp;&nbsp;오픈 월드</button><br>
        <button class="button eventButton"  onclick="getGames('우주', this)">&nbsp;&nbsp;우주</button><br>
        <button class="button eventButton"  onclick="getGames('음악', this)">&nbsp;&nbsp;음악</button><br>
        <button class="button eventButton"  onclick="getGames('인디', this)">&nbsp;&nbsp;인디</button><br>
        <button class="button eventButton"  onclick="getGames('잠입', this)">&nbsp;&nbsp;잠입</button><br>
        <button class="button eventButton"  onclick="getGames('전략', this)">&nbsp;&nbsp;전략</button><br>
        <button class="button eventButton"  onclick="getGames('전투', this)">&nbsp;&nbsp;전투</button><br>
        <button class="button eventButton"  onclick="getGames('카드_게임', this)">&nbsp;&nbsp;카드 게임</button><br>
        <button class="button eventButton"  onclick="getGames('캐주얼', this)">&nbsp;&nbsp;캐주얼</button><br>
        <button class="button eventButton"  onclick="getGames('코미디', this)">&nbsp;&nbsp;코미디</button><br>
        <button class="button eventButton"  onclick="getGames('퀴즈', this)">&nbsp;&nbsp;퀴즈</button><br>
        <button class="button eventButton"  onclick="getGames('타워_디펜스', this)">&nbsp;&nbsp;타워디펜스</button><br>
        <button class="button eventButton"  onclick="getGames('탐험', this)">&nbsp;&nbsp;탐험</button><br>
        <button class="button eventButton"  onclick="getGames('턴_기반_전략', this)">&nbsp;&nbsp;턴기반전략</button><br>
        <button class="button eventButton"  onclick="getGames('턴제', this)">&nbsp;&nbsp;턴제</button><br>
        <button class="button eventButton"  onclick="getGames('파티', this)">&nbsp;&nbsp;파티</button><br>
        <button class="button eventButton"  onclick="getGames('판타지', this)">&nbsp;&nbsp;판타지</button><br>
        <button class="button eventButton"  onclick="getGames('퍼즐', this)">&nbsp;&nbsp;퍼즐</button><br>
        <button class="button eventButton"  onclick="getGames('플랫포머', this)">&nbsp;&nbsp;플랫포머</button><br>
        <button class="button eventButton"  onclick="getGames('호러', this)">&nbsp;&nbsp;호러</button><br>
        <button class="button eventButton"  onclick="getGames('MOBA', this)">&nbsp;&nbsp;MOBA</button><br>
        <button class="button eventButton"  onclick="getGames('RPG', this)">&nbsp;&nbsp;RPG</button><br>
        <button class="button eventButton"  onclick="getGames('RTS', this)">&nbsp;&nbsp;RTS</button><br>
							<br>
						</div>

						<br>
						<br>
						<button class="button eventButton" onclick="showHiddenPlatform()"
							style="border-bottom: 1px solid gray;">
							플랫폼 <img id="platformImage" src="image/32196.png" alt="이벤트 보기 1"
								style="width: 15px; height: 15px; position: relative; left: 166px; bottom: 0px;">
						</button>
						<div id="hiddenPlatform" class="hiddenContent"
							style="color: gray; border-bottom: 1px solid gray;">
							<br> Android<br>
							<br> iOS<br>
							<br> Nintendo Switch<br>
							<br> PC<br>
							<br> PlayStation 4<br>
							<br> PlayStation 5<br>
							<br> Xbox One<br>
							<br> Xbox Series X/S<br>
							<br>
						</div>
					</div>
</div>
					</span>
				</div>
		
					
						<div id="hide4" style="display: none">
							Android<br>
							<br> iOS<br>
							<br> Nintendo Switch<br>
							<br> PC<br>
							<br> PlayStation 4<br>
							<br> PlayStation 5<br>
							<br> Xbox One<br>
							<br> Xbox Series X/S<br>
							<br>
						</div> 





	<div class="main2"></div>

	<script>
		function searchGames() {
			var input = document.getElementById('searchInput');
			var filter = input.value;

			var xhr = new XMLHttpRequest();
			xhr.open('GET', 'searchGamesServlet?searchInput='
					+ encodeURIComponent(filter), true); // 서버 요청을 보내는 URL을 적절히 수정하세요
			xhr.onreadystatechange = function() {
				if (xhr.readyState === 4 && xhr.status === 200) {
					var gameItemsContainer = document
							.getElementById('gameItemsContainer');
					gameItemsContainer.innerHTML = xhr.responseText;
				}
			};
			xhr.send();
		}
	</script>
   <div id="gameList"style="
    position: relative;
    bottom: 200px;
    left: 150px;
">
        <%!
            Connection conn2 = null;
            PreparedStatement pstmt = null;
            ResultSet rs2 = null;
            String uid2 = "admin1";
            String pwd2 = "1234";
            String url2 = "jdbc:oracle:thin:@localhost:1521:XE";
        %>

        <% 
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection(url, uid, pwd);

                String filter = request.getParameter("filter");
                String sql = "SELECT l.g_no, l.title, l.ori_prc, l.thumnail_img " +
                        "FROM game_list l, game_genre g " +
                        "WHERE l.g_no = g.g_no AND g.genre_name = ?";

                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, filter);
	
                rs = pstmt.executeQuery();

                HashSet<String> gameSet = new HashSet<String>();

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
    <% } %>
    <div class="game-row">
    <% } %>
    <div class="game-item">
        <img src="<%= thumnail_img %>" alt="<%= title %>" width="220" height="290" />
        <div class="game-info">
            <%= title %>
            <br>
            <%= ori_prc %>
        </div>
    </div>
    <% 
                    gameCount++;
                    if (gameCount % 5 == 0) {
                        // 5개의 게임 출력 후 다음 행으로 이동
    %>
    </div>
    <div class="game-row">
    <% }
                }

                // 마지막 행 닫기
                if (gameCount > 0 && gameCount % 5 != 0) {
    %>
    </div>
    <% } %>
    <% 
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        
        %>
<script>
	function qwer(count) {
		  var linkUrl = "http://localhost:8090/epicgames/gamepage.jsp";
	      // 현재 창에서 링크를 열기 위해 window.location.href를 사용합니다.
	      window.location.href = linkUrl;
	}
</script>
<table>
    <% Connection conn = getConnection();
       String sql = "SELECT b2.*\r\n" +
               "FROM(SELECT rownum rnum,b1.*\r\n" +
               "FROM(SELECT*FROM game_list ORDER BY g_no desc)b1)b2\r\n" +
               "WHERE rnum>=? AND rnum<=?";

       int endNum = pageNum * 20;
       int startNum = endNum - 19;

       PreparedStatement pstmt = conn.prepareStatement(sql);
       pstmt.setInt(1, startNum);
       pstmt.setInt(2, endNum);

       ResultSet rs = pstmt.executeQuery();

       int count = 0;
       
       while (rs.next()) {
           if (count % 5 == 0) {
               %><tr><%
           }
           %><td id=<%=count %> onclick="qwer(<%=count%>)"><div class="c" ><img src=<%= rs.getString("thumnail_img") %> style="width:220px;height:290px"></div><br>
               <div class="d"> <%= rs.getString("title") %></div><br>
             <%if(rs.getInt("ori_prc")==0){ %> 무료 <%}else if(rs.getInt("ori_prc")>0){ %> ₩<%= rs.getString("ori_prc") %>
             <%}else{ %> 미출시   <%} %><br></td><%
           count++;
           if (count % 5 == 0) {
               %></tr><%
           }
       }
       if (count % 5 != 0) {
           %></tr><%
       }
    %>
</table>
<div style="padding-left: 520px">
    <% for (int i = 1; i <= 10; i++) { %>
        <a href="test.jsp?page=<%= i %>"><%= i %></a>
    <% } %>
</div>

<%
    rs.close();
    pstmt.close();
    conn.close();
%>
<jsp:include page="BottomFooter.jsp"/>
</body>
</html>
