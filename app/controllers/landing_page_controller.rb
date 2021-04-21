class LandingPageController < ApplicationController
  def index
    @display_photos = all_photos.sample(3)
  end

  private

  def all_photos
    "https://cdn.pixabay.com/photo/2014/04/10/15/39/pavilion-321036_960_720.jpg",
    [ "https://cdn.pixabay.com/photo/2015/03/26/10/08/pool-691008_960_720.jpg",
      "https://cdn.pixabay.com/photo/2015/09/09/18/40/dog-932447_960_720.jpg",
      "https://cdn.pixabay.com/photo/2016/07/28/06/05/white-1547092_960_720.jpg",
      "https://cdn.pixabay.com/photo/2016/11/25/19/02/soccer-1859046_960_720.jpg",
      "https://cdn.pixabay.com/photo/2017/04/23/20/39/tree-2254979_960_720.jpg",
      "https://cdn.pixabay.com/photo/2015/03/26/10/29/swings-691446_960_720.jpg"].uniq
  end
end
