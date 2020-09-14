------------ Set path variables ----------------------------------------
\set localpath '\'/Users/erichullander/desktop/myrepos/sql/Creating_Database/'

\set band 'band.csv\''
\set band_path :localpath:band

\set composer 'composer.csv\''
\set composer_path :localpath:composer

\set composition 'composition.csv\''
\set composition_path :localpath:composition

\set concert 'concert.csv\''
\set concert_path :localpath:concert

\set has_composed 'has_composed.csv\''
\set has_composed_path :localpath:has_composed

\set musician 'musician.csv\''
\set musician_path :localpath:musician

\set performer 'performer.csv\''
\set performer_path :localpath:performer

\set performance 'performance.csv\''
\set performance_path :localpath:performance

\set place 'place.csv\''
\set place_path :localpath:place

\set plays_in 'plays_in.csv\''
\set plays_in_path :localpath:plays_in
---------------------------------------------------------------------------


DROP TABLE IF EXISTS band;
CREATE TABLE band
(
band_no INTEGER NOT NULL,
band_name VARCHAR(255),
band_home INTEGER,
band_type VARCHAR(255),
b_date DATE,
band_contact INTEGER,
CONSTRAINT band_pk PRIMARY KEY (band_no)
);

COPY band
FROM :band_path CSV ;

DROP TABLE IF EXISTS composer;
CREATE TABLE composer
(
comp_no INTEGER NOT NULL,
comp_is INTEGER,
comp_type VARCHAR(255),
CONSTRAINT composer_pk PRIMARY KEY (comp_no)
);

COPY composer
FROM :composer_path CSV ;

DROP TABLE IF EXISTS composition;
CREATE TABLE composition
(
c_no INTEGER NOT NULL,
comp_date DATE,
c_title VARCHAR(255),
c_in INTEGER,
CONSTRAINT composition_pk PRIMARY KEY (c_no)
);

COPY composition
FROM :composition_path CSV ;

DROP TABLE IF EXISTS concert;
CREATE TABLE concert
(
concert_no INTEGER NOT NULL,
concert_venue VARCHAR(255),
concert_in INTEGER,
con_date DATE,
concert_orgniser INTEGER,
CONSTRAINT concert_pk PRIMARY KEY (concert_no)
);

COPY concert
FROM :concert_path CSV ;

DROP TABLE IF EXISTS has_composed;
CREATE TABLE has_composed
(
cmpr_no INTEGER NOT NULL,
cmpn_no INTEGER
);

COPY has_composed
FROM :has_composed_path CSV ;


DROP TABLE IF EXISTS musician;
CREATE TABLE musician
(
m_no INTEGER NOT NULL,
m_name VARCHAR(255),
born DATE,
died DATE,
born_in INTEGER,
living_in INTEGER,
CONSTRAINT musician_pk PRIMARY KEY (m_no)
);


COPY musician
FROM :musician_path CSV ;


DROP TABLE IF EXISTS performance;
CREATE TABLE performance
(
pfrmnc_no INTEGER NOT NULL,
gave INTEGER,
performed INTEGER,
conducted_by INTEGER,
performed_in INTEGER,
CONSTRAINT performance_pk PRIMARY KEY (pfrmnc_no)
);

COPY performance
FROM :performance_path CSV ;


DROP TABLE IF EXISTS performer;
CREATE TABLE performer
(
perf_no INTEGER NOT NULL,
perf_is INTEGER,
instrument VARCHAR(255),
perf_type VARCHAR(255),
CONSTRAINT performer_pk PRIMARY KEY (perf_no)
);

COPY performer
FROM :performer_path CSV ;



DROP TABLE IF EXISTS place;
CREATE TABLE place
(
place_no INTEGER NOT NULL,
place_town VARCHAR(255),
place_country VARCHAR(255),
CONSTRAINT place_pk PRIMARY KEY (place_no)
);

COPY place
FROM :place_path CSV ;


DROP TABLE IF EXISTS plays_in;
CREATE TABLE plays_in
(
player INTEGER NOT NULL,
band_id INTEGER
);

COPY plays_in
FROM :plays_in_path CSV ;
