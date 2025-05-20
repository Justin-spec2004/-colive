# backend_server.py

import os
from flask import Flask, request, jsonify

# Configure a folder to temporarily store uploaded files
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024 # Optional: Limit file size (e.g., 16MB)

@app.route('/api/upload', methods=['POST'])
def upload_file():
    """
    API endpoint to receive a file upload.
    """
    if request.method == 'POST':
        # Check if the post request has the file part
        if 'file' not in request.files:
            return jsonify({"error": "No file part in the request"}), 400

        file = request.files['file']

        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400

        if file:
            # WARNING: In a real app, VALIDATE the filename and file type securely!
            # For this basic example, we'll just save it.
            try:
                filename = file.filename # Use werkzeug.utils.secure_filename in production
                save_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                file.save(save_path)
                print(f"File saved successfully to: {save_path}")

                # --- Placeholder for Real Processing ---
                # In a real application, instead of just returning success,
                # you would now:
                # 1. Generate a unique job ID.
                # 2. Add a task to a background queue (like Celery)
                #    to process the file at 'save_path' using the
                #    EcoFont logic (the python-docx script etc.).
                # 3. Immediately return the job ID to the Flutter app.
                #    e.g., return jsonify({"message": "File upload successful, processing started.", "jobId": "some_unique_id"})
                # --- End Placeholder ---

                # For this *minimal* example, just confirm receipt.
                return jsonify({"message": f"File '{filename}' received successfully. NO processing done yet."}), 200

            except Exception as e:
                print(f"Error saving file: {e}")
                return jsonify({"error": "Failed to save file on server"}), 500
        else:
             return jsonify({"error": "File object not valid"}), 400

    # Only POST method is allowed for this route
    return jsonify({"error": "Method Not Allowed"}), 405

# --- Basic Status Endpoint Placeholder ---
@app.route('/api/status/<job_id>', methods=['GET'])
def get_status(job_id):
    # In a real app, you would check the status of the background job
    # associated with 'job_id' in your task queue or database.
    print(f"Received status request for job: {job_id}")
    # Placeholder response:
    return jsonify({
        "jobId": job_id,
        "status": "unknown", # Replace with actual status: "processing", "completed", "failed"
        "message": "Status check placeholder - No real job tracking implemented yet."
        # "results": { ... } # Add results here when completed
        }), 200


if __name__ == '__main__':
    # Make sure to use 0.0.0.0 to make it accessible on your network
    # if you're testing from a physical Flutter device.
    # Use port 5000 or another available port.
    print("Starting Flask server...")
    app.run(host='0.0.0.0', port=5000, debug=True) # debug=True is for development ONLY