import streamlit as st
from crewai import Agent, Task, Crew
from langchain_groq import ChatGroq
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()
groq_api_key = os.getenv("GROQ_API_KEY")

st.set_page_config(page_title="CrewAI Logistic Research Assistant", layout="wide")

st.title("CrewAI Logistic Research Assistant")
st.markdown("--- Say Hello to your AI-powered Logistic Research Team ---")

# Define Agents
logistic_research = Agent(
    role="Logistic Research Specialist",
    goal="Research and find out accurate and relevant information about the logistic topic provided",
    backstory="Expert researcher who is capable of gathering relevant, precise and accurate information about any logistics topic",
    llm="groq/llama-3.1-8b-instant", 
    verbose=True,
    allow_delegation=False
)

logistic_analysis = Agent(
    role="Logistic Data Analyst",
    goal="Analyze the logistics research data, identify key trends, patterns, and insights, and summarize findings in a clear and actionable manner.",
    backstory="A meticulous logistics data analyst with a proven track record of extracting meaningful insights from complex datasets, transforming raw information into strategic recommendations.",
    llm="groq/llama-3.1-8b-instant", 
    verbose=True,
    allow_delegation=False
)

logistic_summarizer = Agent(
    role="Teacher",
    goal="Explain the findings clearly for students",
    backstory="An experienced educator who simplifies complex ideas.",
    llm="groq/llama-3.1-8b-instant", 
    verbose=True,
    allow_delegation=False
)

# Streamlit Input
topic = st.text_input("Enter your Query (e.g., 'export logistics')", "")

if st.button("Run CrewAI"): 
    if topic:
        with st.spinner("Running CrewAI agents..."): 
            # Define Tasks
            research_task = Task(
                description=f"Research about: {topic}. Collect important facts and explanations about the topic.",
                expected_output="Research data about the topic with some key facts as bullet points and other explanations",
                agent=logistic_research
            )

            analysis_task = Task(
                description="Analyse the research findings and identify the key facts and information.",
                expected_output="A list of important insights derived from the research agent's results",
                agent=logistic_analysis
            )

            summary_task = Task(
                description="Summarize the results for research agent and analysis agent and explain the insights in simple words for students.",
                expected_output="Simplified summary of the conclusions and works of research agent and analysis agent",
                agent=logistic_summarizer
            )

            # Instantiate Crew
            project_crew = Crew(
                agents=[logistic_research, logistic_analysis, logistic_summarizer],
                tasks=[research_task, analysis_task, summary_task],
                verbose=True
            )

            # Kickoff the crew
            try:
                result = project_crew.kickoff(inputs={"topic": topic})
                st.subheader("Final Result:")
                st.write(result.raw) 
            except Exception as e:
                st.error(f"An error occurred during CrewAI execution: {e}")
    else:
        st.warning("Please enter a topic to run the CrewAI.")
