## Vector DB Use Case

This section evaluates whether a traditional keyword-based database search would suffice for a law firm's contract search system, and explains the role of a vector database in this context.

### The Problem with Keyword Search

A traditional keyword-based database — such as a SQL `LIKE` query or a basic full-text search index — works by matching exact words or phrases. If a lawyer types *"What are the termination clauses?"*, the system searches for documents containing the literal words "termination" and "clauses." This approach has three critical limitations in a legal context.

First, legal contracts rarely use plain English. A termination clause might be titled *"Cessation of Agreement"* or *"Right to Dissolve Obligations"* — none of which contain the word "termination." A keyword search would return zero results despite highly relevant content being present in the document.

Second, 500-page contracts contain thousands of overlapping terms. Keywords like "party," "liability," or "breach" appear in dozens of unrelated sections. A keyword match returns every occurrence without understanding which section actually answers the lawyer's question, forcing them to manually filter irrelevant results.

Third, keyword search has no concept of meaning or intent. It cannot understand that *"Can we exit the contract early?"* and *"What are the termination clauses?"* are the same question expressed differently.

### The Role of a Vector Database

A vector database solves all three problems through semantic search. When the contract is ingested, each paragraph or clause is converted into a high-dimensional embedding vector using a language model such as `all-MiniLM-L6-v2` or a legal-domain model. These vectors encode the *meaning* of each clause, not just its words.

When a lawyer submits a plain-English question, that query is also converted to a vector. The vector database then performs an Approximate Nearest Neighbour search — finding clauses whose embedding vectors are closest to the query vector in the high-dimensional space.

This means *"What are the termination clauses?"* will correctly surface sections titled *"Cessation of Agreement"* or *"Early Exit Provisions"* because their semantic vectors are similar, even if no keywords match. The system returns ranked, contextually relevant results in milliseconds, even across a 500-page document.

### Recommended Architecture

The recommended stack for this law firm system is: a document parser (to extract clause-level chunks from PDFs), an embedding model (to vectorise each chunk), a vector database such as **Pinecone**, **Weaviate**, or **ChromaDB** (to store and query vectors), and a retrieval-augmented generation layer (to synthesise the top-k retrieved clauses into a natural language answer). This architecture transforms a 500-page contract from a static document into a queryable knowledge base.
