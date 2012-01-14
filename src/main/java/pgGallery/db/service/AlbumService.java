package pgGallery.db.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import pgGallery.db.dao.AlbumMapper;
import pgGallery.db.pojo.Album;


@Service
public class AlbumService {
	@Autowired
	private AlbumMapper albumMapper = null;
	
	public List<Album> getRoot(){
		return albumMapper.getRoot();
	}
	
	public List<Album> getByParent(BigDecimal id){
		return albumMapper.getByParent(id);
	}
	
	public Album getById(BigDecimal id){
		return albumMapper.getById(id);
	}
	
	public List<Album> getBreadcrumbById(BigDecimal id){
		if(id == null) {
			return new ArrayList<Album>();
		}
		List<Album> crumbs = albumMapper.getBreadcrumbById(id);
		Collections.reverse(crumbs);
		return crumbs;
	}
	
	@Transactional
	public void create(Album album){
		albumMapper.create(album);
	}
	
	@Transactional
	public void update(Album album){
		albumMapper.update(album);
	}

	public void setAlbumMapper(AlbumMapper albumMapper) {
		this.albumMapper = albumMapper;
	}
}