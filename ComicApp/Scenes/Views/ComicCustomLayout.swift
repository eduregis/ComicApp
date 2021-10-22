//
//  CustomSegmentedControl.swift
//  ComicApp
//
//  Created by Nathalia Cardoso on 17/09/20.
//  Copyright © 2020 Eduardo Oliveira. All rights reserved.
//

import UIKit

class ComicCustomLayout: UICollectionViewFlowLayout {

  //Duas propriedades que configuram o layout
  //Two properties to configurate the layout
  private let numberOfColumns = 2
  private let cellPadding: CGFloat = 6

  //Um array para armazenar os atributos calculados. Quando você chamar o método prepare(), você calculará os atributos para todos os itens e adiciona-los ao cache. Quando a collectionview solicitar os atributos de layout, você consegue facilmente salvar os atributos sem precisar ficar recalculando.
  // One array to store the calculated attributes. When you call prepare() method, you will calculate the attributes for every ite, and add then to cache. When the collectionView ask for the layout attributes, you can easily save them without have to calculate again.
   var cache: [UICollectionViewLayoutAttributes] = []

  //Duas propriedades para armazenar os tamanhos dos conteúdos. Você incrementa o ContentHeight conforme adiciona fotos e calcula contentWidth baseado no collectionview width e o seu conteudo insets.
  // Two properties to store the content size. You can increment the ContentHeight as you add photos and calculate contentWidth based on the collectionview width and it insets.
  private var contentHeight: CGFloat = 0

  private var contentWidth: CGFloat {
    guard let collectionView = collectionView else {
      return 0
    }
    let insets = collectionView.contentInset
    return collectionView.bounds.width - (insets.left + insets.right)
  }

  // retorna o tamanho daos conteudos da collectionview. Você usará tanto o contentHeight e o contentWidth para calclar o size.
  /// Return: The size of collectionview's contents.
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func prepare() {

    // Só precisaremos calcular os atributos se o cache estiver vazio e a collectionView existir
    // We only need to calculate if the collectionView existe
    guard let collectionView = collectionView else {
      return
    }
    cache.removeAll()
    contentHeight = 0 

    //Declara e preenche o array xOffSet com a coordenada-x oara cada coluna baseada no columnWidth. O yOffSet monitora a posição-y de cada coluna. Você inicializara cada valor de yOffSet como 0 ja que este offset é o primeiro item de cada coluna.
    // Declare and fill the array xOffset with the x-coordinate for every column based on columnWidth. The yOffSet monitor the y-position of every column. You initialize every value of the xOffset with 0 cause this offset is the first item in each column.
    let columnWidth = contentWidth / CGFloat(numberOfColumns)
    var xOffSet: [CGFloat] = []
    for column in 0..<numberOfColumns {
      xOffSet.append(CGFloat(column) * columnWidth)
    }
    var column = 0
    var yOffSet: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

    // Loop em que todos os itens na primeira seção desde que esse layout tenha apenas uma seção
    // Loop witch every item in the first section since this layout has only one section
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)

      // Executa o calculo do frame. Width é o valor calculado anteriormente de cellWith com o padding entre as celulas removidas. É solicitado ao delegate a altura da photo então calculado o frame height baseado na altura e no cellPadding predefinido para top e bottom. Se não existir nenhum delegate configurado, ele utiliza o tamanho padrão de 180. Você então combina isso com o x e y do offset da coluna atual então criar insetFrame usado para este atributo
    let height = prepareHeightFromIndex(index: item)

      let frame = CGRect(x: xOffSet[column],
                         y: yOffSet[column],
                         width: columnWidth,
                         height: height)

      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

      //Cria uma instancia de UICollectionViewLayoutAttributes altera seu frame usando insetFrame e adiciona os atributos ao cache
      // Create one instance of UICollectionViewLayoutAttributes change it frame using insetFrame and add the attributes in cache
      let atributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      atributes.frame = insetFrame
      cache.append(atributes)

      //Expande o contentHeight para se encaixar o frame do novo item calculado. Então, adiciona o atual yOffSet para a coluna atual baseada no frame. Finalmente, adiciona novo coluna assim o proximo item sera adicionado na proxima coluna
      //Expand the contentHeight to fit the frame in the new calculated Item. So, add the current yOffSet, for the current column based on the frame. Finally, add a new column and the next item will be add in the next Column. 
      contentHeight = max(contentHeight, frame.maxY)
      yOffSet[column] = yOffSet[column] + height
      column = column < (numberOfColumns - 1) ? (column + 1) : 0
    }
}

  override func layoutAttributesForElements(in rect: CGRect)
      -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    // Loop through the cache and look for items in the rect
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath)
      -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }

    func prepareHeightFromIndex(index: Int) -> CGFloat {
        if index % 3 == 0 {
            return 180
        } else if index % 3 == 1 {
            return 400
        } else {
            return 230
        }
    }

    func emptyCache() {
        cache = []
    }
}
