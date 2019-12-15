package Resources;

import Resources.LOLApiKey;
	
import java.sql.*;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import net.rithms.riot.*;
import net.rithms.riot.api.ApiConfig;
import net.rithms.riot.api.RiotApi;
import net.rithms.riot.api.RiotApiException;
import net.rithms.riot.api.endpoints.summoner.dto.Summoner;
import net.rithms.riot.constant.Platform;
import net.rithms.riot.api.endpoints.match.*;
import net.rithms.riot.api.endpoints.match.dto.Match;
import net.rithms.riot.api.endpoints.match.dto.MatchList;
import net.rithms.riot.api.endpoints.match.dto.MatchReference;
import net.rithms.riot.api.endpoints.match.dto.Participant;
import net.rithms.riot.api.endpoints.match.dto.ParticipantStats;
import net.rithms.riot.api.endpoints.league.*;
import net.rithms.riot.api.endpoints.league.methods.*;
import net.rithms.riot.api.endpoints.league.constant.*;
import net.rithms.riot.api.endpoints.league.dto.*;

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

	public int setIsUser(String userGameID) {
		//소환사정보 디비삽입
		try {
			String sql = "UPDATE TSUMMONER SET IS_USER=TRUE WHERE SUMMONERNAME=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, userGameID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println(userGameID);
			System.out.println("유저 설정 에러");
		}
		return -1;

	}
	
	public void updateSummoner() {
		try {
			String sql = "select summonername from tsummoner";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			rs = pstmt.executeQuery();
		}catch (Exception e) {
			e.printStackTrace();
		}
		//소환사정보 디비삽입
		try {
			while(rs.next()) {
				LOLApiKey key = new LOLApiKey();
				//api key 설정
				ApiConfig cfg = key.getConfig();
				//api패스 설정
				RiotApi api = new RiotApi(cfg);
				Summoner summoner = api.getSummonerByName(Platform.KR, rs.getString("summonername"));
				System.out.println(rs.getString("summonername"));
				//소환사 정보
				String name = summoner.getName(); //소환사이름
				String id = summoner.getId(); // 소환사 아이디
				int summonerLevel = summoner.getSummonerLevel(); //소환사 레벨
				//리그엔트리에 관련된 정보
				Set<LeagueEntry> leagueEntry = api.getLeagueEntriesBySummonerId(Platform.KR, id);
				List<LeagueEntry> tempList = new ArrayList<LeagueEntry>(leagueEntry);
				//소환사 티어정보
				String leagueName = tempList.get(0).getLeagueId();//리그이름
				int leaguePoints = tempList.get(0).getLeaguePoints();//리그포인트
				String rank = tempList.get(0).getRank();//현재랭크
				String tier = tempList.get(0).getTier();//현재티어
				int win = tempList.get(0).getWins();//승리횟수
				int losses = tempList.get(0).getLosses();//패배횟수
				int totalGames = win + losses;//총 플레이 횟수

				int rankPoint = 0;
				switch(tier) {
				case "CHALLENGER":
					rankPoint += 8000;
					break;
				case "GRANDMASTER":
					rankPoint += 7000;
					break;
				case "MASTER":
					rankPoint += 6000;
					break;
				case "DIAMOND":
					rankPoint += 5000;
					break;
				case "PLATINUM":
					rankPoint += 4000;
					break;
				case "GOLD":
					rankPoint += 3000;
					break;
				case "SILBER":
					rankPoint += 2000;
					break;
				case "BRONZE":
					rankPoint += 1000;
					break;
				case "IRON":
					rankPoint += 0;
					break;
				}
				
				switch(rank) {
				case "I":
					rankPoint += 800;
					break;
				case "II":
					rankPoint += 600;
					break;
				case "III":
					rankPoint += 400;
					break;
				case "IV":
					rankPoint += 200;
					break;
				case "V":
					rankPoint += 0;
					break;
				}
				
				rankPoint += leaguePoints;
				
			String sql = "update tsummoner set summonerLevel=?, tier=?, rank_pos=?, wins=?, losses=?, leaguePoints=?, leagueName=?, totalGames=?, rankPoint=? where summonername=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setInt(1, summonerLevel);
			pstmt.setString(2, tier); //티어보여기
			pstmt.setString(3, rank);
			pstmt.setInt(4, win);
			pstmt.setInt(5, losses);
			pstmt.setInt(6, leaguePoints);
			pstmt.setString(7, leagueName);
			pstmt.setInt(8, totalGames);
			pstmt.setInt(9, rankPoint);
			pstmt.setString(10, name); //이름 보여주기
			pstmt.executeUpdate();
			}
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("소환사정보 에러");
		}
	}
	
	
}
