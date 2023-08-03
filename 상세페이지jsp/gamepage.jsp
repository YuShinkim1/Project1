<%@ page import="java.sql.*"%>
<%@ page import="javax.naming.*, javax.sql.*"%>
<%@ page import="java.util.HashSet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html style="background: black;">
<head>
<meta charset="UTF-8">
<title>상세 페이지</title>
<link rel="stylesheet" type="text/css" href="css/GamePage.css">
<style>
#dod{
    position: relative;
    top: -239px;
    left: -1230px;
    width: 20px;
    height: 20px;
}
#kabtn{
color: gray;
position: relative;
left: -1000px;
bottom: 0px;
}
.nav-item-block {
			background-color: rgb(204, 204, 204);
			height: 50%;
			margin: 0px 16px;
			width: 1px;
		}
</style>
<script>
	function toggleContent() {
		var content = document.getElementById('content');
		var button = document.getElementById('toggleButton');

		if (content.style.maxHeight === '400px') {
			content.style.maxHeight = 'none';
			button.innerHTML = '접기∧';
		} else {
			content.style.maxHeight = '400px';
			button.innerHTML = '펼치기∨';
		}
	}
</script>
<script>
	function toggleContent() {
		var content = document.getElementById('content');
		var button = document.getElementById('toggleButton');

		if (content.style.maxHeight === '400px') {
			content.style.maxHeight = 'none';
			button.innerHTML = '접기∧';
		} else {
			content.style.maxHeight = '400px';
			button.innerHTML = '펼치기∨';
		}
	}
</script>
<script>
        const starSize = 30, maxStar = 5, gutter = 2;//별 크기, 별 개수
        let maskMax = 0; //오버레이 마스크 최대 너비
        window.addEventListener('DOMContentLoaded',()=>{
            //별 이미지 SVG 개수만큼 생성
            for(let i = 0;i < maxStar;i++){
                let el = document.createElement('div');
                //el.classList.add('star');
                el.style.width = starSize + 'px';
                el.style.height = starSize + 'px';
                el.style.marginRight = gutter + 'px';
                //인라인 SVG 이미지 부착
                el.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512"><path fill="none" class="starcolor" d="M381.2 150.3L524.9 171.5C536.8 173.2 546.8 181.6 550.6 193.1C554.4 204.7 551.3 217.3 542.7 225.9L438.5 328.1L463.1 474.7C465.1 486.7 460.2 498.9 450.2 506C440.3 513.1 427.2 514 416.5 508.3L288.1 439.8L159.8 508.3C149 514 135.9 513.1 126 506C116.1 498.9 111.1 486.7 113.2 474.7L137.8 328.1L33.58 225.9C24.97 217.3 21.91 204.7 25.69 193.1C29.46 181.6 39.43 173.2 51.42 171.5L195 150.3L259.4 17.97C264.7 6.954 275.9-.0391 288.1-.0391C300.4-.0391 311.6 6.954 316.9 17.97L381.2 150.3z"/></svg>';
                document.querySelector('.rating').appendChild(el);
            }
            
            maskMax = parseInt(starSize * maxStar + gutter * (maxStar-1));//최대 마스크 너비 계산
            document.querySelector('input[name=ratevalue]').max = maxStar;//입력 필드 최대값 재설정
            setRating(document.querySelector('input[name=ratevalue]').value);//초기 별점 마킹

            //별점 숫자 입력 값 변경 이벤트 리스너
            document.querySelector('input[name=ratevalue]').addEventListener('change',(e)=>{
                const val = e.target.value;
                //계산식 - 마스크 최대 너비에서 별점x별크기를 빼고, 추가로 별점 버림 정수값x거터 크기를 빼서 마스크 너비를 맞춤
                setRating(val);
            })
            
            //별점 마킹 함수
            function setRating(val = 0){
                document.querySelector('.overlay').style.width = parseInt(maskMax - val * starSize - Math.floor(val) * gutter) + 'px';//마스크 크기 변경해서 별점 마킹
            }
            
            //마우스 클릭 별점 변경 이벤트 리스너
            document.querySelector('.rating').addEventListener('click',(e)=>{
                //closest()로 .rating 요소의 왼쪽 위치를 찾아서 현재 클릭한 위치에서 빼야 상대 클릭 위치를 찾을 수 있음.
                const maskSize = parseInt(maskMax - parseInt(e.clientX) + e.target.closest('.rating').getBoundingClientRect().left);//클릭한 위치 기준 마스크 크기 재계산
                document.querySelector('.overlay').style.width = maskSize + 'px'; //오버레이 마스크 크기 변경해서 별점 마킹
                document.querySelector('input[name=ratevalue]').value = Math.floor((maskMax - maskSize) / (starSize + gutter)) + parseFloat(((maskMax - maskSize) % (starSize + gutter) / starSize).toFixed(1));
            })
        })
    </script>
    <script>
        var currentMediaIndex = 0;
        var mediaPaths = [
            <%
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "admin1", "1234");
                Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery("SELECT media_url, media_type FROM game_container WHERE g_no='1011' AND media_type = 1");

                while (resultSet.next()) {
                    String url = resultSet.getString("media_url");
                    int mediaType = resultSet.getInt("media_type");
                    out.println("{\"url\": \"" + url + "\", \"type\": " + mediaType + "},");
                }

                resultSet.close();
                statement.close();
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
        ];

        function switchMedia(index) {
            var nextMediaIndex = index;
            var nextMedia = document.getElementById('nextMedia');
            var currentMedia = document.getElementById('currentMedia');

            nextMedia.innerHTML = '';
            nextMedia.style.display = 'none';

            var mediaType = mediaPaths[nextMediaIndex].type;
            if (mediaType === 0 || mediaType === 1) {
                currentMedia.src = mediaPaths[nextMediaIndex].url;
                currentMedia.style.display = 'block';
            } else if (mediaType === 2) {
                var videoContainer = document.createElement('div');
                videoContainer.classList.add('media-container');

                var video = document.createElement('video');
                video.src = mediaPaths[nextMediaIndex].url;
                video.autoplay = true;
                video.loop = true;
                video.controls = true;
                video.classList.add('media');
                video.style.width = '100%';
                video.style.height = '100%';

                videoContainer.appendChild(video);

                currentMedia.parentNode.replaceChild(videoContainer, currentMedia);
                currentMedia = video;
            }

            currentMediaIndex = nextMediaIndex;
        }

        function switchToPreviousMedia() {
            var previousIndex = (currentMediaIndex - 1 + mediaPaths.length) % mediaPaths.length;
            switchMedia(previousIndex);
        }

        function switchToNextMedia() {
            var nextIndex = (currentMediaIndex + 1) % mediaPaths.length;
            switchMedia(nextIndex);
        }

        window.onload = function() {
            var nextMedia = document.getElementById('nextMedia');
            nextMedia.style.display = "none";
        }
    </script>
</head>
<%!class ContentList {
		int contentType;
		String content;

		ContentList(int contentType, String content) {
			this.contentType = contentType;
			this.content = content;
		}

	}%>
<%
	ArrayList<ContentList> conList = new ArrayList<ContentList>();
HashSet<String> uniqueGenres = new HashSet<>();
HashSet<String> uniqueFeatures = new HashSet<>();
HashSet<String> uniqueContent0 = new HashSet<>();
HashSet<String> uniqueContent1 = new HashSet<>();
HashSet<String> uniqueContent2 = new HashSet<>();
try {
	Class.forName("oracle.jdbc.driver.OracleDriver");
	Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "admin1", "1234");
	Statement stmt = conn.createStatement();
	String sql2="SELECT DISTINCT i.content, content_no, content_type, genre_no, feature_no, n.genre_name, m.feature_name\r\n"
			+ "FROM game_info_content i, game_feature f, game_genre g, genre_number n, feature_number m\r\n"
			+ "WHERE i.g_no = '1011'\r\n" + "  AND i.g_no = f.g_no\r\n" + "  AND f.g_no = g.g_no\r\n"
			+ "  AND n.g_no = g.genre_no\r\n" + "  AND m.g_no = f.feature_no\r\n"
			+ "ORDER BY content_no, content_type ASC";
	ResultSet rs = stmt.executeQuery(sql2);

	// Store unique genre_name and feature_name values in HashSet
	int contentNo = 1;
	while (rs.next()) {
		int contentType = rs.getInt("content_type");
		String content = rs.getString("content");

		if (contentType == 0) {
	uniqueContent0.add(content);
		}

		else if (contentType == 1 || contentNo == rs.getInt("content_no")) {
	uniqueContent1.add(content);
		} else if (contentType == 2 || contentNo == rs.getInt("content_no")) {
	uniqueContent2.add(content);
		}

		String genreName = rs.getString("genre_name");
		String featureName = rs.getString("feature_name");
		uniqueGenres.add(genreName);
		uniqueFeatures.add(featureName);
		contentNo++;
		if (rs.getInt("content_type") != 0) {
	conList.add(new ContentList(contentType, content));
		}
	}

	rs.close();
	stmt.close();
	conn.close();
} catch (Exception e) {
	e.printStackTrace();
}
%>
<body>
<jsp:include page="NavBar2.jsp"/>
<br>
<jsp:include page="NewFile3.jsp"/>
	<%
		String StarLate = "";
	try {
		Class.forName("oracle.jdbc.driver.OracleDriver");
		String sql3="SELECT l.title,p.star_rate\r\n"
				+ "FROM game_list l,game_publishing p\r\n" + "WHERE l.g_no='1011' AND\r\n" + "l.g_no=p.g_no";
		Connection conn= DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "admin1", "1234");
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(sql3);

		while (rs.next()) {
			StarLate = rs.getString("star_rate");
	%>
	<div class="gpage">
	
		<h3 style="color: white; position: relative; top: 120px; left: 180px;"><%=rs.getString("star_rate")%></h3>
		<h1 style="color: white; font-size: 50px;"><%=rs.getString("title")%></h1>

		<div class="container">
			<input Hidden type="number" name="ratevalue"
				value=<%=rs.getString("star_rate")%> step="0.1" min="0"
				max="5" />
			<div class="rating-wrap">
				<div class="rating">
					<div class="overlay"></div>
				</div>
			</div>
		</div>
		

		<script>
		var video = document.getElementById('video');
		var audio = document.getElementById('audio');

		video.addEventListener('play', function() {
			setTimeout(function() {
				audio.play();
				setTimeout(function() {
					video.play();
				}, 10);
			}, 1);
		});

		video.addEventListener('pause', function() {
			setTimeout(function() {
				audio.pause();
				video.pause();
			}, 1);
		});
	</script>

		<script>
		document
				.addEventListener(
						'DOMContentLoaded',
						function() {
							const slideshowContainer = document
									.querySelector('.slideshow-container');
							const slideshow = document
									.querySelector('.slideshow');
							const slides = document.querySelectorAll('.slide');
							const prevButton = document
									.querySelector('#prevButton');
							const nextButton = document
									.querySelector('#nextButton');

							const slideWidth = slides[0].offsetWidth;
							let currentIndex = 0;

							prevButton.addEventListener('click', function() {
								if (currentIndex === 0) {
									currentIndex = slides.length - 1;
								} else {
									currentIndex--;
								}
								updateSlidePosition();
							});

							nextButton.addEventListener('click', function() {
								if (currentIndex === slides.length - 1) {
									currentIndex = 0;
								} else {
									currentIndex++;
								}
								updateSlidePosition();
							});

							function updateSlidePosition() {
								slideshow.style.transform = `translateX(-${currentIndex * slideWidth}px)`;
							}
						});

		document.addEventListener('DOMContentLoaded', function() {
			const rating =
	<%=rs.getString("star_rate")%>
		;
			setRating(rating);
		});


	</script>
		<%
			}
		rs.close();
		stmt.close();
		conn.close();
		} catch (Exception e) {
		e.printStackTrace();
		}
		%>
		<br>
		<br>
		<div class="t">
			<h2>소개 &emsp;업적</h2>
		</div>
		<div class="u">
		<div class="media-container">
			<%-- 현재 미디어 --%>
			<img id="currentMedia" class="media"
				style="width: 1040px; height: 580px;" onclick="switchMedia(0)">
			<%
				try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				String sql4="SELECT media_type,media_url,l.g_no\r\n" + "FROM game_list l,game_container c \r\n"
						+ "WHERE l.g_no='1011' AND\r\n" + "l.g_no=c.g_no AND\r\n" + "media_type='1'";
				Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "admin1", "1234");
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt
				.executeQuery(sql4);
			%>
			<%
				if (rs.next()) {

				String url = rs.getString("media_url");
				int mediaType = rs.getInt("media_type");
				if (mediaType == 0 || mediaType == 1) {
					out.println("<script>document.getElementById('currentMedia').src='" + url + "';</script>");
				} else if (mediaType == 2) {
					out.println(
					"<script>var videoContainer = document.createElement('div'); videoContainer.classList.add('media-container'); var video = document.createElement('video'); video.src='"
							+ url
							+ "'; video.autoplay=true; video.loop=true; video.controls=true; video.classList.add('media'); video.style.width='100%'; video.style.height='100%'; videoContainer.appendChild(video); document.getElementById('currentMedia').parentNode.replaceChild(videoContainer, document.getElementById('currentMedia'));</script>");
				}
			}

			rs.close();
			stmt.close();
			conn.close();
			} catch (Exception e) {
			e.printStackTrace();
			}
			%>
<%
			String spec_min_g = "";
		String spec_rcmd_g = "";
		String os = "";
		String os2 = "";
		String process = "";
		String process2 = "";
		String memory = "";
		String memory2 = "";
		String storage = "";
		String storage2 = "";
		String directx = "";
		String directx2 = "";
		String login = "";
		String language = "";
		String age_lmt = "";
		String rfd_type = "";
		String developer = "";
		String publisher = "";
		String platform = "";
		String release_date = "";
		String price = "";
		String formatted_date = "";

		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			String sql6="SELECT TO_CHAR(release_date, 'YYYY-MM-DD') AS formatted_date, m.graphic,r.graphic graphic_1,p.platform,ori_prc,m.os,r.os os_1,m.process,r.process process_1,\r\n"
					+ "m.memory,r.memory memory_1,m.storage,r.storage storage_1,m.directx,r.directx directx_1,m.login,m.language,p.age_lmt\r\n"
					+ ",p.rfd_type,p.developer,p.publisher,p.platform\r\n"
					+ "FROM game_spec_min m,game_spec_rcmd r,game_publishing p,game_list l\r\n"
					+ "WHERE m.g_no=r.g_no AND\r\n" + "m.g_no=p.g_no AND\r\n" + "m.g_no=l.g_no AND\r\n"
					+ "m.g_no='1011'";
			Connection conn5 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "admin1", "1234");
			Statement stmt5 = conn5.createStatement();
			ResultSet rs5 = stmt5.executeQuery(
			sql6);

			// Store unique genre_name and feature_name values in HashSet
			while (rs5.next()) {
				spec_min_g = rs5.getString("graphic");
				spec_rcmd_g = rs5.getString("graphic_1");
				os = rs5.getString("os");
				os2 = rs5.getString("os_1");
				process = rs5.getString("process");
				process2 = rs5.getString("process_1");
				memory = rs5.getString("memory");
				memory2 = rs5.getString("memory_1");
				storage = rs5.getString("storage");
				storage2 = rs5.getString("storage_1");
				directx = rs5.getString("directx");
				directx2 = rs5.getString("directx_1");
				login = rs5.getString("login");
				language = rs5.getString("language");
				age_lmt = rs5.getString("age_lmt");
				rfd_type = rs5.getString("rfd_type");
				developer = rs5.getString("developer");
				publisher = rs5.getString("publisher");
				platform = rs5.getString("platform");
				price = rs5.getString("ori_prc");
				formatted_date = rs5.getString("formatted_date");
			}

			rs5.close();
			stmt5.close();
			conn5.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		%>
			<%-- 다음 미디어 (숨겨진 미디어) --%>
			<div id="nextMedia" class="media media-hidden"></div>
		</div>
				<div class="g" style="color: white;">
				<div style="display:flex;">
				<%if (age_lmt.equals("청소년이용불가")){%>
				<img src="https://cdn1.epicgames.com/gameRating/gameRating/GRAC_18_192_192x192-41a622e1b3505df23b588fe3a47a94d6" style="
    width: 50px;
    height: 50px;
">
				<%}else if (age_lmt.equals("전체이용가")){%>
				<img src="https://cdn1.epicgames.com/gameRating/gameRating/GRAC_All_192_192x192-0973b9b3768114fdfa4d864efd697ae2" style="
    width: 50px;
    height: 50px;
">
<%}else if (age_lmt.equals("12세 이용가")){%>
<img src="https://cdn1.epicgames.com/gameRating/gameRating/GRAC_12_192_192x192-2873c81e2512ccd4d3fb02a00458ab19" style="
    width: 50px;
    height: 50px;
">
	<%} else{%>
	<img src="https://cdn1.epicgames.com/gameRating/gameRating/GRAC_15_192_192x192-b372dc9edcaffa17d685c440496b9f21" style="
    width: 50px;
    height: 50px;
">
	<%} %>			
				
				<div style="
    position: relative;
    top: 15px;">
				&emsp;<%=age_lmt%>
				</div>
				</div>
				<br>
				<div class="xx">기본 게임</div>
				<br><span id="zz">₩<%=price%></span>
				<br>
				<br>
				<button id="gamepagebtn">지금 구매</button>
				<br>
				<br>
				<button id="gamepagebtn2">장바구니</button>
				<br>
				<br>
				<div class="j">
					환불유형&emsp;
					<div class="k"><%=rfd_type%></div>
				</div>
				<div class="j">
					개발사&emsp;
					<div class="k"><%=developer%></div>
				</div>
				<div class="j">
					퍼블리셔&emsp;
					<div class="k"><%=publisher%></div>
				</div>
				<div class="j">
					출시일&emsp;
					<div class="k"><%=formatted_date%></div>
				</div>
				<div class="j">
					플랫폼&emsp;
					<div class="k"><%=platform%></div>
				</div>
				<br>
				<button id="gamepagebtn3">
					<svg width="16" height="18" fill="currentColor"
						xmlns="http://www.w3.org/2000/svg">
						<path
							d="M13 12.4003C12.3667 12.4003 11.8 12.6503 11.3667 13.042L5.425 9.58366C5.46667 9.39199 5.5 9.20033 5.5 9.00033C5.5 8.80033 5.46667 8.60866 5.425 8.41699L11.3 4.99199C11.75 5.40866 12.3417 5.66699 13 5.66699C14.3833 5.66699 15.5 4.55033 15.5 3.16699C15.5 1.78366 14.3833 0.666992 13 0.666992C11.6167 0.666992 10.5 1.78366 10.5 3.16699C10.5 3.36699 10.5333 3.55866 10.575 3.75033L4.7 7.17533C4.25 6.75866 3.65833 6.50033 3 6.50033C1.61667 6.50033 0.5 7.61699 0.5 9.00033C0.5 10.3837 1.61667 11.5003 3 11.5003C3.65833 11.5003 4.25 11.242 4.7 10.8253L10.6333 14.292C10.5917 14.467 10.5667 14.6503 10.5667 14.8337C10.5667 16.1753 11.6583 17.267 13 17.267C14.3417 17.267 15.4333 16.1753 15.4333 14.8337C15.4333 13.492 14.3417 12.4003 13 12.4003Z"
							fill="currentColor"></path></svg>
					&emsp;공유
				</button>
				<button id="gamepagebtn3">
					<svg width="16" height="18" xmlns="http://www.w3.org/2000/svg"
						class="svg css-uwwqev" viewBox="0 0 18 14">
						<g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
						<g transform="translate(-666.000000, -890.000000)"
							fill="currentColor" fill-rule="nonzero">
						<g transform="translate(666.000000, 859.000000)">
						<g transform="translate(0.000000, 31.000000)">
						<g id="flag-(3)">
						<g>
						<path
							d="M13.0113,0.9438 C12.9504,0.9195 11.4933,0.3447 9.7668,0.3447 C8.7366,0.3447 7.8258,0.5508 7.0596,0.9573 C6.3807,1.3176 5.4597,1.5 4.3221,1.5 C2.7297,1.5 1.1595,1.1364 0.6,0.9921 L0.6,0.3 C0.6,0.1341 0.4659,0 0.3,0 C0.1341,0 3.64153152e-13,0.1341 3.64153152e-13,0.3 L3.64153152e-13,1.2 C3.64153152e-13,1.2042 0.0021,1.2078 0.0024,1.212 C0.0024,1.2156 3.64153152e-13,1.2186 3.64153152e-13,1.2222 L3.64153152e-13,9.9 L3.64153152e-13,10.2222 L3.64153152e-13,17.7 C3.64153152e-13,17.8659 0.1341,18 0.3,18 C0.4659,18 0.6,17.8659 0.6,17.7 L0.6,10.6119 C1.2819,10.7811 2.7729,11.1 4.3221,11.1 C5.5587,11.1 6.5742,10.8936 7.3407,10.4874 C8.0196,10.1271 8.8356,9.9444 9.7668,9.9444 C11.3739,9.9444 12.7749,10.4952 12.7887,10.5006 C12.8814,10.5378 12.9858,10.5264 13.0683,10.47 C13.1505,10.4148 13.2,10.3218 13.2,10.2222 L13.2,1.2222 C13.2,1.0995 13.1253,0.9894 13.0113,0.9438 Z"
							id="Path"></path></g></g></g></g></g></g></svg>
					&emsp;신고
				</button>
			</div>
			</div>
		<%-- 이전 미디어 버튼 --%>
		<button onclick="switchToPreviousMedia()"
			style="position: relative; bottom: 313px; background: #00ff0000; border: solid 1px #00ff0000; color: white;"><</button>
		<%-- 다음 미디어 버튼 --%>
		<button onclick="switchToNextMedia()"
			style="position: relative; bottom: 313px; left: 987px; background: #00ff0000; border: solid 1px #00ff0000; color: white;">></button>
		<div>
			<%-- 이미지 버튼들 --%>
        <div id="imageButtonsContainer" style="
    position: relative;
    left: 150px;
">
        <img src="image/left.png" alt="left Image"
					style="width: 50px; height: 50px; position: relative; right: 150px;">
            <% 
            int index = 0;
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "admin1", "1234");
                Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery("SELECT media_url, media_type FROM game_container WHERE g_no='1011' AND media_type = 1");

                int imageCount = 0; // 이미지 개수를 세기 위한 변수
                while (resultSet.next() && imageCount < 6) { // 최대 6개 이미지까지만 표시
                    String url = resultSet.getString("media_url");
                    int mediaType = resultSet.getInt("media_type");
                    if (mediaType == 0 || mediaType == 1) {
                        out.println("<img src=\"" + url + "\" style=\"width: 100px; height: 50px;\" onclick=\"switchMedia(" + index + ")\">");
                        imageCount++;
                    } else if (mediaType == 2) {
                        out.println("<button onclick=\"switchMedia(" + index + ")\">영상 " + (index + 1) + "</button>");
                    }
                    index++;
                }

                resultSet.close();
                statement.close();
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
						
				<img src="image/right.png" alt="right Image"
					style="width: 50px; height: 50px; position: relative; left: 150px;">
			</div>

		</div>
		<h3>
			<%
				// Print unique Content with content_type 0
			for (String content : uniqueContent0) {
				out.print(content);
			}
			%>
		</h3>

		<div class="a">
			<div class="b" style="color: gray">
				&emsp;장르<br>&nbsp;&nbsp;
				<%
					// Print unique genre_names
				int genreCount = uniqueGenres.size();
				int currentGenreIndex = 0;
				for (String genreName : uniqueGenres) {
					out.print(genreName);
					currentGenreIndex++;
					if (currentGenreIndex < genreCount) {
						out.print(",");
					}
				}
				%>
			</div>
			<div class="b" style="color: gray">
				&emsp;기능<br>&nbsp;&nbsp;
				<%
					// Print unique feature_names
				int featureCount = uniqueFeatures.size();
				int currentFeatureIndex = 0;
				for (String featureName : uniqueFeatures) {
					out.print(featureName);
					currentFeatureIndex++;
					if (currentFeatureIndex < featureCount) {
						out.print(",");
					}
				}
				%>
			</div>
		</div>
		<div id="content">
			<%
				for (int i = 1, j = 1; i <= (conList.size() / 6); i++) {
				
					if(i%2!=0){%>
			<h4 style="color:gray;"><%=conList.get(j).content%></h4>
			<%} else if(i%2==0){ %>
			<h4 style="color:white;"><%=conList.get(j).content%></h4>
			<%} %>
			
			<%
				j += 6;
			}
			%>
		</div>
		<button id="toggleButton" onclick="toggleContent()">펼치기∨</button>
		<br> <br>
		<h3>획득 가능 업적</h3>
		<div class="y">
			
			<div class="n">
				<div>
					<img
						src="image\reward1.png"
						style="width: 128px; height: 144px;">
				</div>
				<div>초보 닌자</div>
				<div class="l">
					<svg color="gold" width="20" height="20px"
						xmlns="http://www.w3.org/2000/svg" class="svg css-uwwqev"
						viewBox="0 0 15 14">
						<path
							d="M1.78952 1.03177H3.21722C3.21547 1.05694 3.21455 1.08267 3.21455 1.10896L3.21455 2.21484H1.92245V3.65386C1.92245 4.29719 2.17572 4.91418 2.62655 5.36908C2.8022 5.54633 3.00223 5.69331 3.21869 5.8067C3.23933 6.28339 3.33644 6.74005 3.49797 7.16449C2.85933 7.01104 2.26929 6.68172 1.7975 6.20565C1.1268 5.52887 0.75 4.61096 0.75 3.65386V2.0807C0.75 1.50139 1.21541 1.03177 1.78952 1.03177Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M4.57719 7.26263C4.37731 6.90243 4.24094 6.50149 4.18336 6.07526L4.17941 6.04498C4.16166 5.90411 4.15251 5.76052 4.15251 5.61478L4.15251 1.10896C4.15251 1.02488 4.24618 0.944783 4.41557 0.871928C4.92375 0.653363 6.11342 0.5 7.49999 0.5C9.34874 0.5 10.8475 0.772637 10.8475 1.10895V5.61478C10.8475 5.77097 10.837 5.9247 10.8166 6.07526C10.7459 6.59904 10.5561 7.0846 10.2758 7.50333C9.6742 8.40183 8.65546 8.99257 7.49999 8.99257L7.47834 8.9925C6.23167 8.98454 5.14668 8.28891 4.57719 7.26263Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M11.502 7.1645C11.6635 6.74006 11.7606 6.2834 11.7813 5.80672C11.9978 5.69332 12.1978 5.54634 12.3735 5.36908C12.8243 4.91418 13.0775 4.29719 13.0775 3.65386V2.21484H11.8227V1.03177H13.2105C13.7846 1.03177 14.25 1.50139 14.25 2.0807V3.65386C14.25 4.61096 13.8732 5.52887 13.2025 6.20565C12.83 6.58157 12.3836 6.866 11.898 7.04457C11.7686 7.09215 11.6364 7.13221 11.502 7.1645Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M10.3826 12.1379C10.3826 12.7521 9.09198 13.25 7.49998 13.25C5.90798 13.25 4.6174 12.7521 4.6174 12.1379C4.6174 11.9371 4.75526 11.7488 4.99644 11.5862L4.99892 11.5845L5.54498 11.2735C6.0756 10.9712 6.51643 10.5312 6.82173 9.99911C6.90651 9.85135 7.12539 9.74247 7.49998 9.74247C7.87457 9.74247 8.09345 9.85135 8.17823 9.99911C8.48353 10.5312 8.92435 10.9712 9.45498 11.2735L10.001 11.5845L10.008 11.5893C10.2464 11.7511 10.3826 11.9384 10.3826 12.1379Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
					<div>100xp</div>
				</div>
				
			</div>
			
				<div class="n">
				<div>
					<img
						src="image\reward2.png"
						style="width: 128px; height: 144px;">
				</div>
				<div>지하 세계 신입</div>
				<div class="l">
					<svg color="silver" width="20" height="20px"
						xmlns="http://www.w3.org/2000/svg" class="svg css-uwwqev"
						viewBox="0 0 15 14">
						<path
							d="M1.78952 1.03177H3.21722C3.21547 1.05694 3.21455 1.08267 3.21455 1.10896L3.21455 2.21484H1.92245V3.65386C1.92245 4.29719 2.17572 4.91418 2.62655 5.36908C2.8022 5.54633 3.00223 5.69331 3.21869 5.8067C3.23933 6.28339 3.33644 6.74005 3.49797 7.16449C2.85933 7.01104 2.26929 6.68172 1.7975 6.20565C1.1268 5.52887 0.75 4.61096 0.75 3.65386V2.0807C0.75 1.50139 1.21541 1.03177 1.78952 1.03177Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M4.57719 7.26263C4.37731 6.90243 4.24094 6.50149 4.18336 6.07526L4.17941 6.04498C4.16166 5.90411 4.15251 5.76052 4.15251 5.61478L4.15251 1.10896C4.15251 1.02488 4.24618 0.944783 4.41557 0.871928C4.92375 0.653363 6.11342 0.5 7.49999 0.5C9.34874 0.5 10.8475 0.772637 10.8475 1.10895V5.61478C10.8475 5.77097 10.837 5.9247 10.8166 6.07526C10.7459 6.59904 10.5561 7.0846 10.2758 7.50333C9.6742 8.40183 8.65546 8.99257 7.49999 8.99257L7.47834 8.9925C6.23167 8.98454 5.14668 8.28891 4.57719 7.26263Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M11.502 7.1645C11.6635 6.74006 11.7606 6.2834 11.7813 5.80672C11.9978 5.69332 12.1978 5.54634 12.3735 5.36908C12.8243 4.91418 13.0775 4.29719 13.0775 3.65386V2.21484H11.8227V1.03177H13.2105C13.7846 1.03177 14.25 1.50139 14.25 2.0807V3.65386C14.25 4.61096 13.8732 5.52887 13.2025 6.20565C12.83 6.58157 12.3836 6.866 11.898 7.04457C11.7686 7.09215 11.6364 7.13221 11.502 7.1645Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M10.3826 12.1379C10.3826 12.7521 9.09198 13.25 7.49998 13.25C5.90798 13.25 4.6174 12.7521 4.6174 12.1379C4.6174 11.9371 4.75526 11.7488 4.99644 11.5862L4.99892 11.5845L5.54498 11.2735C6.0756 10.9712 6.51643 10.5312 6.82173 9.99911C6.90651 9.85135 7.12539 9.74247 7.49998 9.74247C7.87457 9.74247 8.09345 9.85135 8.17823 9.99911C8.48353 10.5312 8.92435 10.9712 9.45498 11.2735L10.001 11.5845L10.008 11.5893C10.2464 11.7511 10.3826 11.9384 10.3826 12.1379Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
					<div>50xp</div>
				</div>
				
				
			</div>
			<div class="n">
				<div>
					<img
						src="image\reward3.png"
						style="width: 128px; height: 144px;">
				</div>
				<div>로이드 레인저</div>
				<div class="l">
					<svg color="rgb(202,81,43)" width="20" height="20px"
						xmlns="http://www.w3.org/2000/svg" class="svg css-uwwqev"
						viewBox="0 0 15 14">
						<path
							d="M1.78952 1.03177H3.21722C3.21547 1.05694 3.21455 1.08267 3.21455 1.10896L3.21455 2.21484H1.92245V3.65386C1.92245 4.29719 2.17572 4.91418 2.62655 5.36908C2.8022 5.54633 3.00223 5.69331 3.21869 5.8067C3.23933 6.28339 3.33644 6.74005 3.49797 7.16449C2.85933 7.01104 2.26929 6.68172 1.7975 6.20565C1.1268 5.52887 0.75 4.61096 0.75 3.65386V2.0807C0.75 1.50139 1.21541 1.03177 1.78952 1.03177Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M4.57719 7.26263C4.37731 6.90243 4.24094 6.50149 4.18336 6.07526L4.17941 6.04498C4.16166 5.90411 4.15251 5.76052 4.15251 5.61478L4.15251 1.10896C4.15251 1.02488 4.24618 0.944783 4.41557 0.871928C4.92375 0.653363 6.11342 0.5 7.49999 0.5C9.34874 0.5 10.8475 0.772637 10.8475 1.10895V5.61478C10.8475 5.77097 10.837 5.9247 10.8166 6.07526C10.7459 6.59904 10.5561 7.0846 10.2758 7.50333C9.6742 8.40183 8.65546 8.99257 7.49999 8.99257L7.47834 8.9925C6.23167 8.98454 5.14668 8.28891 4.57719 7.26263Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M11.502 7.1645C11.6635 6.74006 11.7606 6.2834 11.7813 5.80672C11.9978 5.69332 12.1978 5.54634 12.3735 5.36908C12.8243 4.91418 13.0775 4.29719 13.0775 3.65386V2.21484H11.8227V1.03177H13.2105C13.7846 1.03177 14.25 1.50139 14.25 2.0807V3.65386C14.25 4.61096 13.8732 5.52887 13.2025 6.20565C12.83 6.58157 12.3836 6.866 11.898 7.04457C11.7686 7.09215 11.6364 7.13221 11.502 7.1645Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M10.3826 12.1379C10.3826 12.7521 9.09198 13.25 7.49998 13.25C5.90798 13.25 4.6174 12.7521 4.6174 12.1379C4.6174 11.9371 4.75526 11.7488 4.99644 11.5862L4.99892 11.5845L5.54498 11.2735C6.0756 10.9712 6.51643 10.5312 6.82173 9.99911C6.90651 9.85135 7.12539 9.74247 7.49998 9.74247C7.87457 9.74247 8.09345 9.85135 8.17823 9.99911C8.48353 10.5312 8.92435 10.9712 9.45498 11.2735L10.001 11.5845L10.008 11.5893C10.2464 11.7511 10.3826 11.9384 10.3826 12.1379Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
					<div>10xp</div>
				</div>
				
			</div>
			
			<div class="n">
				<div>
					<img
						src="image\reward4.png"
						style="width: 128px; height: 144px;">
				</div>
				<div>숨겨진 소나타</div>
				<div class="l">
					<svg color="gold" width="20" height="20px"
						xmlns="http://www.w3.org/2000/svg" class="svg css-uwwqev"
						viewBox="0 0 15 14">
						<path
							d="M1.78952 1.03177H3.21722C3.21547 1.05694 3.21455 1.08267 3.21455 1.10896L3.21455 2.21484H1.92245V3.65386C1.92245 4.29719 2.17572 4.91418 2.62655 5.36908C2.8022 5.54633 3.00223 5.69331 3.21869 5.8067C3.23933 6.28339 3.33644 6.74005 3.49797 7.16449C2.85933 7.01104 2.26929 6.68172 1.7975 6.20565C1.1268 5.52887 0.75 4.61096 0.75 3.65386V2.0807C0.75 1.50139 1.21541 1.03177 1.78952 1.03177Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M4.57719 7.26263C4.37731 6.90243 4.24094 6.50149 4.18336 6.07526L4.17941 6.04498C4.16166 5.90411 4.15251 5.76052 4.15251 5.61478L4.15251 1.10896C4.15251 1.02488 4.24618 0.944783 4.41557 0.871928C4.92375 0.653363 6.11342 0.5 7.49999 0.5C9.34874 0.5 10.8475 0.772637 10.8475 1.10895V5.61478C10.8475 5.77097 10.837 5.9247 10.8166 6.07526C10.7459 6.59904 10.5561 7.0846 10.2758 7.50333C9.6742 8.40183 8.65546 8.99257 7.49999 8.99257L7.47834 8.9925C6.23167 8.98454 5.14668 8.28891 4.57719 7.26263Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M11.502 7.1645C11.6635 6.74006 11.7606 6.2834 11.7813 5.80672C11.9978 5.69332 12.1978 5.54634 12.3735 5.36908C12.8243 4.91418 13.0775 4.29719 13.0775 3.65386V2.21484H11.8227V1.03177H13.2105C13.7846 1.03177 14.25 1.50139 14.25 2.0807V3.65386C14.25 4.61096 13.8732 5.52887 13.2025 6.20565C12.83 6.58157 12.3836 6.866 11.898 7.04457C11.7686 7.09215 11.6364 7.13221 11.502 7.1645Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M10.3826 12.1379C10.3826 12.7521 9.09198 13.25 7.49998 13.25C5.90798 13.25 4.6174 12.7521 4.6174 12.1379C4.6174 11.9371 4.75526 11.7488 4.99644 11.5862L4.99892 11.5845L5.54498 11.2735C6.0756 10.9712 6.51643 10.5312 6.82173 9.99911C6.90651 9.85135 7.12539 9.74247 7.49998 9.74247C7.87457 9.74247 8.09345 9.85135 8.17823 9.99911C8.48353 10.5312 8.92435 10.9712 9.45498 11.2735L10.001 11.5845L10.008 11.5893C10.2464 11.7511 10.3826 11.9384 10.3826 12.1379Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
					<div>150xp</div>
				</div>
				
			</div>
			<div class="n">
				<div>
					<img
						src="image\reward5.png"
						style="width: 128px; height: 144px;">
				</div>
				<div>별 추적</div>
				<div class="l">
					<svg color="silver" width="20" height="20px"
						xmlns="http://www.w3.org/2000/svg" class="svg css-uwwqev"
						viewBox="0 0 15 14">
						<path
							d="M1.78952 1.03177H3.21722C3.21547 1.05694 3.21455 1.08267 3.21455 1.10896L3.21455 2.21484H1.92245V3.65386C1.92245 4.29719 2.17572 4.91418 2.62655 5.36908C2.8022 5.54633 3.00223 5.69331 3.21869 5.8067C3.23933 6.28339 3.33644 6.74005 3.49797 7.16449C2.85933 7.01104 2.26929 6.68172 1.7975 6.20565C1.1268 5.52887 0.75 4.61096 0.75 3.65386V2.0807C0.75 1.50139 1.21541 1.03177 1.78952 1.03177Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M4.57719 7.26263C4.37731 6.90243 4.24094 6.50149 4.18336 6.07526L4.17941 6.04498C4.16166 5.90411 4.15251 5.76052 4.15251 5.61478L4.15251 1.10896C4.15251 1.02488 4.24618 0.944783 4.41557 0.871928C4.92375 0.653363 6.11342 0.5 7.49999 0.5C9.34874 0.5 10.8475 0.772637 10.8475 1.10895V5.61478C10.8475 5.77097 10.837 5.9247 10.8166 6.07526C10.7459 6.59904 10.5561 7.0846 10.2758 7.50333C9.6742 8.40183 8.65546 8.99257 7.49999 8.99257L7.47834 8.9925C6.23167 8.98454 5.14668 8.28891 4.57719 7.26263Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M11.502 7.1645C11.6635 6.74006 11.7606 6.2834 11.7813 5.80672C11.9978 5.69332 12.1978 5.54634 12.3735 5.36908C12.8243 4.91418 13.0775 4.29719 13.0775 3.65386V2.21484H11.8227V1.03177H13.2105C13.7846 1.03177 14.25 1.50139 14.25 2.0807V3.65386C14.25 4.61096 13.8732 5.52887 13.2025 6.20565C12.83 6.58157 12.3836 6.866 11.898 7.04457C11.7686 7.09215 11.6364 7.13221 11.502 7.1645Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path>
						<path
							d="M10.3826 12.1379C10.3826 12.7521 9.09198 13.25 7.49998 13.25C5.90798 13.25 4.6174 12.7521 4.6174 12.1379C4.6174 11.9371 4.75526 11.7488 4.99644 11.5862L4.99892 11.5845L5.54498 11.2735C6.0756 10.9712 6.51643 10.5312 6.82173 9.99911C6.90651 9.85135 7.12539 9.74247 7.49998 9.74247C7.87457 9.74247 8.09345 9.85135 8.17823 9.99911C8.48353 10.5312 8.92435 10.9712 9.45498 11.2735L10.001 11.5845L10.008 11.5893C10.2464 11.7511 10.3826 11.9384 10.3826 12.1379Z"
							fill="currentColor" fill-rule="evenodd" clip-rule="evenodd"></path></svg>
					<div>50xp</div>
				</div>
				
			</div>
		</div>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>

		<br>
				<h3>에픽 플레이어 평가</h3>
		<h5>에픽게임즈 에코시스템 내 플레이어의 의견입니다.</h5>
		<div class="rating-wrap2">
			<div class="rating">
				<div class="overlay" style="width: 70px;"></div>
				<h1 style="color: white; font-size: 40px;"><%=StarLate%></h1>
				&emsp;&emsp;
				<div style="width: 60px; height: 60px; margin-right: 4px;">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
						<path fill="none" class="starcolor"
							d="M381.2 150.3L524.9 171.5C536.8 173.2 546.8 181.6 550.6 193.1C554.4 204.7 551.3 217.3 542.7 225.9L438.5 328.1L463.1 474.7C465.1 486.7 460.2 498.9 450.2 506C440.3 513.1 427.2 514 416.5 508.3L288.1 439.8L159.8 508.3C149 514 135.9 513.1 126 506C116.1 498.9 111.1 486.7 113.2 474.7L137.8 328.1L33.58 225.9C24.97 217.3 21.91 204.7 25.69 193.1C29.46 181.6 39.43 173.2 51.42 171.5L195 150.3L259.4 17.97C264.7 6.954 275.9-.0391 288.1-.0391C300.4-.0391 311.6 6.954 316.9 17.97L381.2 150.3z"></path></svg>
				</div>
				<div style="width: 60px; height: 60px; margin-right: 4px;">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
						<path fill="none" class="starcolor"
							d="M381.2 150.3L524.9 171.5C536.8 173.2 546.8 181.6 550.6 193.1C554.4 204.7 551.3 217.3 542.7 225.9L438.5 328.1L463.1 474.7C465.1 486.7 460.2 498.9 450.2 506C440.3 513.1 427.2 514 416.5 508.3L288.1 439.8L159.8 508.3C149 514 135.9 513.1 126 506C116.1 498.9 111.1 486.7 113.2 474.7L137.8 328.1L33.58 225.9C24.97 217.3 21.91 204.7 25.69 193.1C29.46 181.6 39.43 173.2 51.42 171.5L195 150.3L259.4 17.97C264.7 6.954 275.9-.0391 288.1-.0391C300.4-.0391 311.6 6.954 316.9 17.97L381.2 150.3z"></path></svg>
				</div>
				<div style="width: 60px; height: 60px; margin-right: 4px;">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
						<path fill="none" class="starcolor"
							d="M381.2 150.3L524.9 171.5C536.8 173.2 546.8 181.6 550.6 193.1C554.4 204.7 551.3 217.3 542.7 225.9L438.5 328.1L463.1 474.7C465.1 486.7 460.2 498.9 450.2 506C440.3 513.1 427.2 514 416.5 508.3L288.1 439.8L159.8 508.3C149 514 135.9 513.1 126 506C116.1 498.9 111.1 486.7 113.2 474.7L137.8 328.1L33.58 225.9C24.97 217.3 21.91 204.7 25.69 193.1C29.46 181.6 39.43 173.2 51.42 171.5L195 150.3L259.4 17.97C264.7 6.954 275.9-.0391 288.1-.0391C300.4-.0391 311.6 6.954 316.9 17.97L381.2 150.3z"></path></svg>
				</div>
				<div style="width: 60px; height: 60px; margin-right: 4px;">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
						<path fill="none" class="starcolor"
							d="M381.2 150.3L524.9 171.5C536.8 173.2 546.8 181.6 550.6 193.1C554.4 204.7 551.3 217.3 542.7 225.9L438.5 328.1L463.1 474.7C465.1 486.7 460.2 498.9 450.2 506C440.3 513.1 427.2 514 416.5 508.3L288.1 439.8L159.8 508.3C149 514 135.9 513.1 126 506C116.1 498.9 111.1 486.7 113.2 474.7L137.8 328.1L33.58 225.9C24.97 217.3 21.91 204.7 25.69 193.1C29.46 181.6 39.43 173.2 51.42 171.5L195 150.3L259.4 17.97C264.7 6.954 275.9-.0391 288.1-.0391C300.4-.0391 311.6 6.954 316.9 17.97L381.2 150.3z"></path></svg>
				</div>
				<div style="width: 60px; height: 60px; margin-right: 4px;">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
						<path fill="none" class="starcolor"
							d="M381.2 150.3L524.9 171.5C536.8 173.2 546.8 181.6 550.6 193.1C554.4 204.7 551.3 217.3 542.7 225.9L438.5 328.1L463.1 474.7C465.1 486.7 460.2 498.9 450.2 506C440.3 513.1 427.2 514 416.5 508.3L288.1 439.8L159.8 508.3C149 514 135.9 513.1 126 506C116.1 498.9 111.1 486.7 113.2 474.7L137.8 328.1L33.58 225.9C24.97 217.3 21.91 204.7 25.69 193.1C29.46 181.6 39.43 173.2 51.42 171.5L195 150.3L259.4 17.97C264.7 6.954 275.9-.0391 288.1-.0391C300.4-.0391 311.6 6.954 316.9 17.97L381.2 150.3z"></path></svg>
				</div>
			</div>
		</div>
		<br>
		<h3>사양</h3>
		
			<div class="z">
				<br> <br>

				<div class="x">
					<table>
						<tr class="tableTop">
							<th>최소</th>
							<th>권장</th>
						</tr>
						<tr class="tableContent">
							<th>운영체제</th>
							<th>운영체제</th>
						</tr>
						<tr class="tableContent">
							<td><%=os%></td>
							<td><%=os2%></td>
						</tr>
						<tr class="tableContent">
							<th>프로세서</th>
							<th>프로세서</th>
						</tr>
						<tr class="tableContent">
							<td><%=process%></td>
							<td><%=process2%></td>
						</tr>
						<tr class="tableContent">
							<th>메모리</th>
							<th>메모리</th>
						</tr>
						<tr class="tableContent">
							<td><%=memory%></td>
							<td><%=memory2%></td>
						</tr>
						<tr class="tableContent">
							<th>스토리지</th>
							<th>스토리지</th>
						</tr>
						<tr class="tableContent">
							<td><%=storage%></td>
							<td><%=storage2%></td>
						</tr>
						<tr class="tableContent">
							<th>DirectX</th>
							<th>DirectX</th>
						</tr>
						<tr class="tableContent">
							<td><%=directx%></td>
							<td><%=directx2%></td>
						</tr>
						<tr class="tableContent">
							<th>그래픽카드</th>
							<th>그래픽카드</th>
						</tr>
						<tr class="tableContent">
							<td><%=spec_min_g%></td>
							<td><%=spec_rcmd_g%></td>
						</tr>

						<tr class="tableContent">
							<th>로그인</th>
						</tr>
						<tr class="tableContent">
							<td colspan="2"><%=login%></td>
						</tr>
						<tr class="tableContent">
							<th>지원언어</th>
						</tr>
						<tr class="tableContent">
							<td colspan="2"><%=language%></td>
						</tr>
					</table>
				</div>
			</div>
			<br>
			<br>
</div>

<jsp:include page="BottomFooter.jsp"/>
	
</body>
</html>
