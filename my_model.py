from transformers import GPT2LMHeadModel, GPT2Tokenizer, GPT2Config
from transformers import TextDataset, DataCollatorForLanguageModeling
from transformers import Trainer, TrainingArguments
import os
import fitz

# Load your physics textbook PDF and extract text
# This step might involve using a PDF parsing library like PyMuPDF

def extract_text_from_pdf(pdf_path):
    doc = fitz.open(pdf_path)
    text = ""
    for page_num in range(doc.page_count):
        page = doc[page_num]
        text += page.get_text()
    doc.close()
    return text



def train_model():
    pdf_path = input('Enter path to pdf: ')
    # For simplicity, let's assume you have extracted the text into a variable named 'physics_text'
    physics_text = extract_text_from_pdf(pdf_path=pdf_path)

    # Save the text to a file
    with open("physics_text.txt", "w", encoding="utf-8") as file:
        file.write(physics_text)

    # Load pre-trained GPT-2 model and tokenizer
    model_name = "gpt2"
    model = GPT2LMHeadModel.from_pretrained(model_name)
    tokenizer = GPT2Tokenizer.from_pretrained(model_name)

    # Tokenize and create a dataset
    train_dataset = TextDataset(
        tokenizer=tokenizer,
        file_path="physics_text.txt",
        block_size=128
    )

    # Data collator for language modeling
    data_collator = DataCollatorForLanguageModeling(
        tokenizer=tokenizer,
        mlm=False
    )

    # Training arguments
    training_args = TrainingArguments(
        output_dir="./physics_model",
        overwrite_output_dir=True,
        num_train_epochs=3,
        per_device_train_batch_size=4,
        save_steps=10_000,
        save_total_limit=2,
    )

    # Trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        data_collator=data_collator,
        train_dataset=train_dataset,
    )

    # Train the model
    trainer.train()

    # Save the fine-tuned model
    model.save_pretrained("./physics_model")
    tokenizer.save_pretrained("./physics_model")

# Load the fine-tuned model and tokenizer

def generate_answer(question):
    model_path = "./physics_model"
    model = GPT2LMHeadModel.from_pretrained(model_path)
    tokenizer = GPT2Tokenizer.from_pretrained(model_path)

    # Tokenize the input question
    input_ids = tokenizer.encode(question, return_tensors="pt")

    # Generate the answer
    output = model.generate(input_ids, max_length=100, num_beams=5, no_repeat_ngram_size=2, top_k=50)

    # Decode and return the answer
    answer = tokenizer.decode(output[0], skip_special_tokens=True)
    return answer


def main():
    val = input('Train? ').upper()
    if (val == 'Yes'):
        train_model()
    question = input('Ask your question: ')
    print(generate_answer(question=question))
if __name__ == '__main__':
    main()