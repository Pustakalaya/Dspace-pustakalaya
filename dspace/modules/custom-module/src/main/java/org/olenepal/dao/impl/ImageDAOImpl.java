package org.olenepal.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.olenepal.dao.AbstractDAO;
import org.olenepal.dao.ImageDAO;
import org.olenepal.model.Image;
import org.springframework.stereotype.Repository;

@Repository(value="imageDAO")
public class ImageDAOImpl extends AbstractDAO<Long, Image> implements ImageDAO{

	@SuppressWarnings("unchecked")
	@Override
	public List<Image> findAllImage() {
		Criteria crit = (Criteria) createEntityCriteria();
        return (List<Image>)crit.list();
	}

	@Override
	public Image findImageById(Long id) {
		
		return getByKey(id);
	}

	@Override
	public void save(Image image) {
		persist(image);
		
	}

	@Override
	public void deleteImageById(Long id) {
		Image image =  getByKey(id);
        delete(image);
		
	}
 
}
