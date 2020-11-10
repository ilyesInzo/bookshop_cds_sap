namespace sap.capire.bookshop;

using { Currency, managed, cuid } from '@sap/cds/common';
using { sap.capire.products.Products } from '../../products/db/shema';

entity Books : additionalInfo, Products {
    author   : Association to Authors;
}

entity Magaziners : Products{
publisher: String;
}
// without this annotation, author will not be showed in cat-service
// as it is not implemented 
// and in addition expand=author will not work when requesting books
@cds.autoexpose
entity Authors : managed {
  key ID : Integer;
  name   : String(111);
  dateOfBirth  : Date;
  dateOfDeath  : Date;
  placeOfBirth : String;
  placeOfDeath : String;
  books  : Association to many Books on books.author = $self;
}

entity Orders : cuid, managed {
  OrderNo  : String @title:'Order Number'; //> readable key
  Items    : Composition of many OrderItems on Items.parent = $self;
  total    : Decimal(9,2) @readonly;
  currency : Currency;
}
entity OrderItems : cuid {
  parent    : Association to Orders;
  book      : Association to Books;
  amount    : Integer;
  netAmount : Decimal(9,2);
}

aspect additionalInfo {
    gender   : String(100);
    language : String(200);
}

entity Movies : additionalInfo {
    key ID   : Integer;
        name : String;
}
