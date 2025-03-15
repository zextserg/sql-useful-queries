-- Details of arguments can be found here: https://api.python.langchain.com/en/latest/_modules/langchain_community/vectorstores/pgvector.html#PGVector.similarity_search_with_score
CREATE INDEX langchain_pg_embedding_hnsw_ind ON langchain_pg_embedding USING hnsw (embedding vector_cosine_ops) WITH (efsearch=2);
CREATE INDEX langchain_pg_embedding_ivfflat_index ON langchain_pg_embedding USING ivfflat (embedding vector_cosine_ops) WITH (lists = 1000);

-- You can check progress of index creating using command:
SELECT phase, round(100.0 * blocks_done / nullif(blocks_total, 0), 1) AS "%" FROM pg_stat_progress_create_index;
