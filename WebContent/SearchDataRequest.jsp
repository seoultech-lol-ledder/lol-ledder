<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>

<%@ page import="net.rithms.riot.*"%>
<%@ page import="net.rithms.riot.api.ApiConfig"%>
<%@ page import="net.rithms.riot.api.RiotApi"%>
<%@ page import="net.rithms.riot.api.RiotApiException"%>
<%@ page import="net.rithms.riot.api.endpoints.summoner.dto.Summoner"%>
<%@ page import="net.rithms.riot.constant.Platform"%>
<%@ page import="net.rithms.riot.api.endpoints.match.*"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.Match"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.MatchList"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.MatchReference"%>
<%@ page import="net.rithms.riot.api.endpoints.match.dto.Participant"%>
<%@ page
	import="net.rithms.riot.api.endpoints.match.dto.ParticipantStats"%>
<%@ page import="net.rithms.riot.api.endpoints.league.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.methods.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.constant.*"%>
<%@ page import="net.rithms.riot.api.endpoints.league.dto.*"%>

<%
	request.setCharacterEncoding("utf-8");
%>
<%
	//api key 설정
	ApiConfig cfg = new ApiConfig().setKey("RGAPI-329cf0ef-286c-4e81-b472-176dcdb0b23f");
	//api패스 설정
	RiotApi api = new RiotApi(cfg);
	//소환사 이름으로 소환사id값을 찾기위함
	Summoner summoner = api.getSummonerByName(Platform.KR, request.getParameter("name"));
	//소환사 정보
	String name = summoner.getName(); //소환사이름
	String acountId = summoner.getAccountId(); //계정 아이디
	String id = summoner.getId(); // 소환사 아이디
	int summonerLevel = summoner.getSummonerLevel(); //소환사 레벨
	int profileIconId = summoner.getProfileIconId(); //프로필아이콘아이디
	//최근 20경기에 대한 매치리스트
	MatchList matchList = api.getMatchListByAccountId(Platform.KR, acountId);
	//리그엔트리에 관련된 정보
	Set<LeagueEntry> leagueEntry = api.getLeagueEntriesBySummonerId(Platform.KR, id);
	//리그포지션의 경우 해쉬셋이므로 get()메소드를 사용할 수 없기때문에 어레이리스트로 바꿔서 저장하여 가져오기
	//이때 해쉬셋에 들어있는 정보는 객체.size()로 확인하기...int index = 객체.size();
	List<LeagueEntry> tempList = new ArrayList<LeagueEntry>(leagueEntry);
	//매치리스트와 관련된 레퍼런스들
	List<MatchReference> matchListRef = matchList.getMatches();
	//매치 스텟관련 정보들
	Match checkStats = api.getMatch(Platform.KR, matchListRef.get(0).getGameId());
	//소환사 티어정보
	String leagueName = tempList.get(0).getLeagueId();//리그이름
	int leaguePoints = tempList.get(0).getLeaguePoints();//리그포인트
	String rank = tempList.get(0).getRank();//현재랭크
	String tier = tempList.get(0).getTier();//현재티어
	int win = tempList.get(0).getWins();//승리횟수
	int losses = tempList.get(0).getLosses();//패배횟수

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	body{
		background-color : #5CD1E5;
		background-image : url(mainimage.jpg);background-size : 100%;
	}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>데이터 저장 중
</title>
</head>
<body>
	<%
		Connection dbcon = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean found;
		int temp=0;
		
		String DB_URL = "jdbc:mysql://localhost:3306/lol_ledder_db?serverTimezone=UTC";
		String DB_USER = "root";
		String DB_PASSWORD = "root";
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		//소환사정보 디비삽입
		try {
			String sql = "insert into tSummoner(summonerid,accountid, summonername,summonerlevel,profileiconid) values(?,?,?,?,?)";
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, acountId);
			pstmt.setString(3, name); //이름 보여주기
			pstmt.setInt(4, summonerLevel); //레벨 보여주기
			pstmt.setInt(5, profileIconId);
			pstmt.executeUpdate();
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("소환사정보 에러");
		}
		//티어정보 디비삽입
		try {
			String sql = "insert into tTierList(Tier, Rank_pos, Wins,Losses,LeaguePoints,LeagueName,SummonerID) values(?,?,?,?,?,?,?)";
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, tier); //티어보여죽
			pstmt.setString(2, rank);
			pstmt.setInt(3, win);
			pstmt.setInt(4, losses);
			pstmt.setInt(5, leaguePoints);
			pstmt.setString(6, leagueName);
			pstmt.setString(7, id);
			pstmt.executeUpdate();
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("티어정보 에러");
		}
		//참가자인덱스 받아오기
		try{
			String sql = "select count(participateid) from tparticipatestat";
			pstmt = dbcon.prepareStatement(sql);
			rs = pstmt.executeQuery();
			while(rs.next()){
				temp = rs.getInt("count(participateid)");
			}
		}catch(Exception e){}
		
		//매치리스트 디비삽입
		try {
			String sql = "insert into tMatchlist(matchid,totalgames,ParticipateID,SummonerID) values(?,?,?,?)";
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setLong(1, matchListRef.get(0).getGameId());
			pstmt.setInt(2, matchList.getTotalGames());
			pstmt.setInt(3, temp);
			pstmt.setString(4, id);
			pstmt.executeUpdate();
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("매치리스트 에러");
		}
		pstmt.close();
		rs.close();
		dbcon.close();
	%>

</body>
</html>