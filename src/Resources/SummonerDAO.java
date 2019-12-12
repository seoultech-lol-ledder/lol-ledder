package Resources;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class SummonerDAO {

	private Connection dbcon; 
	private ResultSet rs;

	// mysql에 접속해 주는 부분
	public SummonerDAO() { // 생성자 실행될때마다 자동으로 db연결이 이루어 질 수 있도록함
		String DB_URL = "jdbc:mysql://localhost:3306/lol_ledder_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
		String DB_USER = "root";
		String DB_PASSWORD = "root";
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			dbcon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int insertSummoner(String id,String acountId, String name, int summonerLevel, 
			int profileIconId,String tier,String rank,
			int win, int losses, int leaguePoints, String leagueName,
			int totalGames, int rankPoint) {
		//소환사정보 디비삽입
		try {
			String sql = "insert into tSummoner(summonerid,accountid, summonername,summonerlevel,profileiconid, Tier, Rank_pos, Wins,Losses,LeaguePoints,LeagueName,totalgames, rankpoint) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, acountId);
			pstmt.setString(3, name); //이름 보여주기
			pstmt.setInt(4, summonerLevel); //레벨 보여주기
			pstmt.setInt(5, profileIconId);
			pstmt.setString(6, tier); //티어보여기
			pstmt.setString(7, rank);
			pstmt.setInt(8, win);
			pstmt.setInt(9, losses);
			pstmt.setInt(10, leaguePoints);
			pstmt.setString(11, leagueName);
			pstmt.setInt(12, totalGames);
			pstmt.setInt(13, rankPoint);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("소환사정보 에러");
		}
		return -1;
	}
	
	public boolean foundSummoner(String name) {
		try {
			String sql = "select * from tsummoner where summonername=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			return rs.next();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public String getChampionName(int championId) {
		try {
			String sql = "select CHAMPION_NAME from tChampion_data where CHAMPION_ID =?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setInt(1, championId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return rs.getString("CHAMPION_NAME");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(championId);
			System.out.println("챔피언이름 불러오기 오류");
		}
		return "e";
	}
	
	public String getChampionImage(int championId) {
		try {
			String sql = "select image from tChampion_data where CHAMPION_ID =?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setInt(1, championId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return rs.getString("image");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(championId);
			System.out.println("챔피언이미지 불러오기 오류");
		}
		return "e";
	}
	
	public void setSummonerData(String name, SummonerDatas sd) {
		try {
			String sql = "select * from tsummoner where summonername=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				sd.setAccountId(rs.getString("accountid")); //계정아이디
				sd.setId(rs.getString("summonerid")); //소환사아이디
				sd.setName(rs.getString("summonername")); //소환사명
				sd.setSummonerLevel(rs.getLong("summonerlevel")); //소환사레벨
				sd.setProfileIconId(rs.getInt("profileiconid")); //프로필
				sd.setRank(rs.getString("rank_pos")); //소환사 랭크
				sd.setTier(rs.getString("tier")); //소환사 티어
				sd.setWin(rs.getInt("wins")); //소환사 승리
				sd.setLosses(rs.getInt("losses")); //소환사 패배
				sd.setLeagueName(rs.getString("leaguename")); //리그명
				sd.setLeaguePoints(rs.getInt("leaguepoints")); //리그포인트
				sd.setTotalGame(rs.getInt("totalgames"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("소환사 정보 불러오기 오류");
		}
	}
	
	public String getSummonerName(String userId) {
		try {
			String sql = "select userGameID from USER where userID =?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return rs.getString("userGameID");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(userId);
			System.out.println("게임 닉네임 불러오기 에러");
		}
		return "e";
	}
	
	
}
