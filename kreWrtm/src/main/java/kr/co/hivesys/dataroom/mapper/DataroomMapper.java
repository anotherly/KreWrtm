package kr.co.hivesys.dataroom.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.comm.file.vo.FileVo;
import kr.co.hivesys.dataroom.vo.DataroomVO;

/**
 * 자료실 매퍼 클래스
 * @author 솔루션 디자인팀 최다슬
 * @since 2025.09.05
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자              수정내용
 *  -------    -------- ---------------------------
 *  2025.09.05  최다슬          최초 생성
 */

@Mapper("dataroomMapper")
public interface DataroomMapper {

	// 자료실 데이터 조회
	public List<DataroomVO> selectDataList (DataroomVO dataVO) throws Exception;
	
	// 자료실 게시판 데이터 조회
	public List<DataroomVO> selectDataBoardList(DataroomVO dataVO) throws Exception;
	
	// 자료실 상세 정보 조회
	public DataroomVO selectData(DataroomVO dataVO) throws Exception;
	
	// 자료실 게시판 상세 정보 조회  
	public DataroomVO selectDataBoard(DataroomVO dataVO) throws Exception;
	
	// 자료실 자료 등록
	public void insertFile(FileVo fileList) throws Exception;
	
	// 자료실 게시판 등록
	public void insertFileBoard(FileVo fileList) throws Exception;
	
	// 자료실 자료 수정
	public void updateFile(FileVo fileList) throws Exception;
	
	// 게시판 수정
	public void updateFileBoard(FileVo fileList) throws Exception;
	
	// 자료실 자료 삭제
	public void deleteData(HashMap<String, Object> map);
	
	// 게시판 자료 삭제
	public void deleteDataBaord(HashMap<String, Object> map);
	
}
