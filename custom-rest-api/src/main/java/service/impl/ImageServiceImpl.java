package service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import dao.ImageDAO;
import model.Image;
import service.ImageService;

@Service
@Transactional
public class ImageServiceImpl implements ImageService {

	@Autowired
	ImageDAO imageDAO;

	@Override
	public Image findImageById(Long id) {

		return imageDAO.findImageById(id);
	}

	@Override
	public List<Image> findAllImage() {
		// TODO Auto-generated method stub
		return imageDAO.findAllImage();
	}

	@Override
	public void saveImage(Image image) {
		imageDAO.save(image);

	}

	@Override
	public void deleteImageById(Long id) {
		imageDAO.deleteImageById(id);

	}

}
